# SDRplay hardware support: udev rules so the RSP devices are accessible
# without root, and an overlay fixing nixpkgs' `sdrplay` package (the
# proprietary API/driver), which is currently broken two ways:
#   - the pinned installer URL (v3.15.1) 404s; SDRplay only hosts v3.15.2 now
#   - that newer installer renamed its per-arch dirs (x86_64 -> amd64, ...),
#     which breaks upstream's installPhase
# SDR++ itself (built against this same `pkgs.sdrplay`) is enabled per-user
# in modules/home/sdrpp.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.sdr.enable = lib.mkEnableOption "SDR (Software Defined Radio) hardware support: SDRplay driver + udev rules";

  config = lib.mkIf config.my.sdr.enable {
    nixpkgs.overlays = [
      (final: prev: {
        sdrplay = prev.sdrplay.overrideAttrs (old: rec {
          version = "3.15.2";
          src = prev.fetchurl {
            url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
            hash = "sha256-OpfKdkJju+dvsPIiDmQIlCNX6IZMGeFAim1ph684L+M=";
          };
          installPhase = ''
            mkdir -p $out/{bin,lib,include,lib/udev/rules.d}
            libName="libsdrplay_api"
            cp "amd64/$libName.so.$majorMinorVersion" $out/lib/
            ln -s "$out/lib/$libName.so.$majorMinorVersion" "$out/lib/$libName.so.$majorVersion"
            ln -s "$out/lib/$libName.so.$majorVersion" "$out/lib/$libName.so"
            cp "amd64/sdrplay_apiService" $out/bin/
            cp -r inc/* $out/include/
            awk 'index($0, "cat > /etc/udev/rules.d/66-sdrplay.rules"){flag=1; next} /EOF/{flag=0} flag' install_lib.sh > $out/lib/udev/rules.d/66-sdrplay.rules
          '';
        });
      })
    ];

    services.udev.packages = [ pkgs.sdrplay ];
  };
}
