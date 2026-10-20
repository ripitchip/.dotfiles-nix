{
  config,
  lib,
  inputs,
  osConfig,
  pkgs,
  ...
}:
let
  # Same as Signal (see signal.nix): Chromium doesn't know niri and would keep
  # saved passwords and cookies' key in plain text; use the Secret Service (oo7)
  # instead. The package takes its flags directly, no rewrap needed.
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium.override {
    flags = [ "--password-store=gnome-libsecret" ];
  };
in
{
  options.my.helium.enable = lib.mkEnableOption "Helium, an ungoogled-chromium-based browser with uBlock Origin built in";

  config = lib.mkIf config.my.helium.enable {
    home.packages = [ helium ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/net.imput.helium" # profile: settings, bookmarks, extensions, sessions
    ];
  };
}
