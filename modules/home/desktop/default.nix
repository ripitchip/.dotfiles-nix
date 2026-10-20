{ config, lib, ... }:
{
  imports = [
    ./clipboard.nix
    ./fuzzel.nix
    ./theme.nix
    ./waybar.nix
  ];

  options.my.desktop.enable = lib.mkEnableOption "the niri user session: config, terminal, launcher, clipboard history, waybar, swaylock, dark theme";

  config = lib.mkIf config.my.desktop.enable {
    # niri itself is installed system-wide by modules/nixos/desktop.nix
    xdg.configFile."niri/config.kdl".source = ./niri.kdl;

    programs.kitty = {
      enable = true;
      # Silent bell
      settings.enable_audio_bell = false;
    };

    # Bound to Super+Alt+L in niri.kdl
    programs.swaylock.enable = true;
  };
}
