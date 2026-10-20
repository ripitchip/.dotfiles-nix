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

    environment.systemPackages = with pkgs; [
      wl-clipboard # xclip doesn't work under Wayland
      playerctl # media keys in niri.kdl
      # X11 apps (Steam, ...): niri starts it on demand and sets DISPLAY,
      # as long as it's in PATH
      xwayland-satellite
    ];

    fonts.packages = with pkgs; [
      fira-mono
      hack-font
      inconsolata
      iosevka
    ];
  };
}
