{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.zellij.enable = lib.mkEnableOption "zellij, started by default in kitty";

  config = lib.mkIf config.my.zellij.enable {
    programs.zellij = {
      enable = true;
      # Any config.kdl skips the first-run keybinding wizard. ~/.config/zellij
      # is wiped on reboot (impermanence): without it, the wizard, the tips
      # and the release notes would come back after every boot
      settings = {
        show_startup_tips = false;
        show_release_notes = false;
        # Copy selections with wl-copy rather than through the terminal (OSC 52),
        # so they reliably reach the Wayland clipboard and cliphist (Mod+C)
        copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
      };
    };

    # Every kitty window opens a new zellij session, which runs $SHELL in its
    # panes. Only kitty: a TTY or an SSH login stays a plain shell
    programs.kitty.settings.shell = "zellij";
  };
}
