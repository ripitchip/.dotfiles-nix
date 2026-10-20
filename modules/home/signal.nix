{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Electron doesn't know niri and falls back to keeping the database key in
  # plain text in ~/.config/Signal/config.json. Force the Secret Service (oo7,
  # see modules/nixos/desktop.nix; "gnome-libsecret" is just libsecret's name):
  # Signal moves an existing plain-text key there on the next start.
  # (Overriding commandLineArgs would rebuild Signal from source.)
  signal-desktop = pkgs.symlinkJoin {
    name = "signal-desktop";
    paths = [ pkgs.signal-desktop ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/signal-desktop --add-flags --password-store=gnome-libsecret
    '';
  };
in
{
  options.my.signal.enable = lib.mkEnableOption "Signal Desktop and gurk, a Signal client in the terminal";

  config = lib.mkIf config.my.signal.enable {
    home.packages = [
      signal-desktop
      pkgs.gurk-rs # `gurk`; messages in ~/.local/share/gurk, already persisted
    ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Signal" # linked device keys and messages
      ".config/gurk" # gurk.toml: settings, optional passphrase
    ];
  };
}
