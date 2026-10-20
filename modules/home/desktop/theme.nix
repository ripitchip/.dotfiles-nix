{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.desktop.enable {
    # Cursor for GTK apps, XWayland and ~/.icons/default; niri takes the same
    # name and size from its `cursor` block in niri.kdl
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      gtk.enable = true;
    };

    # Dark mode: libadwaita apps, Firefox and Electron apps (Signal, Bitwarden,
    # ...) read color-scheme through the GNOME portal
    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    # GTK3 apps: dark variant of the default Adwaita. Not gtk.theme.name =
    # "Adwaita-dark": home-manager would also write it to dconf's gtk-theme,
    # and Electron then ignores color-scheme and stays light
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.theme = null;
    };
  };
}
