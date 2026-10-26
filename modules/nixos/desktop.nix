{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.desktop.enable = lib.mkEnableOption "the niri Wayland desktop with the ly login manager";

  config = lib.mkIf config.my.desktop.enable {
    programs.niri.enable = true;
    services.displayManager.ly.enable = true;

    hardware.graphics.enable = true;

    # swaylock needs a PAM service to check the password
    security.pam.services.swaylock = { };

    # Secret Service (org.freedesktop.secrets) for Signal, browsers, ...:
    # oo7 instead of the gnome-keyring niri turns on. pam_oo7 unlocks the login
    # keyring with the session password (ly includes the `login` PAM stack).
    # Same file format as gnome-keyring, in ~/.local/share/keyrings (persisted).
    # No password prompt outside GNOME/KDE, so it relies on that PAM unlock.
    # CLI: `oo7-cli`.
    services.oo7.enable = true;
    services.gnome.gnome-keyring.enable = false;
    xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "oo7-portal";

    # File manager, bound to Mod+E in niri.kdl. A system module rather than
    # home.packages: Thunar keeps its settings in xfconf, a D-Bus service.
    programs.thunar.enable = true;
    # Orchis theme for Thunar only, through GTK_THEME in its wrapper: setting
    # it globally (gtk.theme in home-manager) also writes dconf's gtk-theme,
    # which makes Electron ignore color-scheme (see modules/home/desktop/theme.nix).
    # The dbus/systemd service files point at the same wrapped binary
    programs.thunar.package = pkgs.thunar.override {
      thunar-unwrapped = pkgs.thunar-unwrapped.overrideAttrs (old: {
        preFixup = (old.preFixup or "") + ''
          gappsWrapperArgs+=(--set GTK_THEME Orchis-Dark)
        '';
      });
    };
    # USB drives: udisks2 detects and mounts them (no root needed from an
    # active session, through polkit); gvfs lists them in Thunar's sidebar,
    # click to mount, eject button to unmount. Also gives Thunar its trash.
    # Mounted under /run/media/<user>/<label>.
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    environment.persistence.${config.my.impermanence.persistPath}.users.${config.my.user.name}.directories = [
      ".config/xfce4" # xfconf: Thunar preferences
      ".config/Thunar" # shortcuts, custom actions
    ];

    environment.systemPackages = with pkgs; [
      wl-clipboard # xclip doesn't work under Wayland
      playerctl # media keys in niri.kdl
      # X11 apps (Steam, ...): niri starts it on demand and sets DISPLAY,
      # as long as it's in PATH
      xwayland-satellite
      # In share/themes for Thunar's GTK_THEME above
      orchis-theme
    ];

    fonts.packages = with pkgs; [
      fira-mono
      hack-font
      inconsolata
      iosevka
    ];
  };
}
