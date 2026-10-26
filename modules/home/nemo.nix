{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.nemo.enable = lib.mkEnableOption "Nemo, the default file manager (bound to Mod+E in niri.kdl)";

  config = lib.mkIf config.my.nemo.enable {
    home.packages = [
      pkgs.nemo
      # Nemo's "Open Terminal Here" looks up its terminal through
      # org.cinnamon.desktop.default-applications.terminal, a Cinnamon
      # schema nemo doesn't bundle itself: without it GSettings can't find
      # the schema and the action does nothing. Its default ("gnome-terminal")
      # isn't installed either, so it's overridden to kitty below.
      pkgs.cinnamon-desktop
    ];

    dconf.settings = {
      # Bookmarks (modules/home/desktop/theme.nix) already list Documents,
      # Downloads, etc.; Nemo inserts them before Recent/Computer/Trash in
      # its sidebar by default (sidebar-bookmark-breakpoint = -1), so the
      # only thing left to hide is the automatic Desktop entry.
      "org/nemo/desktop" = {
        show-desktop-icons = false;
      };
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
      };
    };

    # dconf.settings above only overwrites the keys it sets: the rest of
    # Nemo's dconf state (window size, last location, ...) still needs
    # ".config/dconf" to survive impermanence, already persisted by
    # nocturne.nix (same desktop.enable lifetime, one shared dconf database).

    # VS Code's .desktop also claims inode/directory (to open folders as a
    # workspace), and wins the xdg-mime fallback when nothing else is set:
    # "open folder" from elsewhere would launch VS Code instead of Nemo.
    xdg.mimeApps.defaultApplications."inode/directory" = "nemo.desktop";
  };
}
