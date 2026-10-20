{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Same as Signal (see signal.nix): Electron doesn't know niri and would keep
  # its encryption key (GitHub login, ...) in plain text; use the Secret Service
  # (oo7) instead.
  vscode = pkgs.symlinkJoin {
    name = "vscode";
    paths = [ pkgs.vscode ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/code --add-flags --password-store=gnome-libsecret
    '';
  };
in
{
  options.my.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config = lib.mkIf config.my.vscode.enable {
    home.packages = [ vscode ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Code" # settings, keybindings, login, workspace state
      ".vscode" # extensions
    ];
  };
}
