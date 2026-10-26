{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Electron doesn't know niri and falls back to an unsupported-keyring
  # prompt instead of finding the Secret Service (oo7, see
  # modules/nixos/desktop.nix; "gnome-libsecret" is just libsecret's name).
  # Same fix as modules/home/signal.nix.
  element-desktop = pkgs.symlinkJoin {
    name = "element-desktop";
    paths = [ pkgs.element-desktop ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/element-desktop --add-flags --password-store=gnome-libsecret
    '';
  };
in
{
  options.my.element.enable = lib.mkEnableOption "Element Desktop, a Matrix client";

  config = lib.mkIf config.my.element.enable {
    home.packages = [ element-desktop ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Element" # session, settings, E2E crypto keys
    ];
  };
}
