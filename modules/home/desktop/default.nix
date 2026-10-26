{ config, lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./clipboard.nix
    ./fuzzel.nix
    ./theme.nix
    ./waybar.nix
    ./wallpaper.nix
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

    # XDG Terminal Exec spec (implemented natively by GLib/GIO): apps that
    # need to run something in a terminal (e.g. Nautilus-style "Open
    # Terminal", GNOME Text Editor) look this up instead of a hardcoded
    # list, which otherwise fails with "could not find a fallback terminal
    # emulator application" since no gnome-terminal/xterm is installed here.
    xdg.configFile."xdg-terminals.list".text = "kitty.desktop\n";

    # Bound to Super+Alt+L in niri.kdl
    programs.swaylock.enable = true;
  };
}
