{ config, lib, ... }:
let
  # Same folder as niri's own screenshots (Print)
  savePath = "${config.home.homeDirectory}/pictures/screenshots";
in
{
  options.my.flameshot.enable = lib.mkEnableOption "Flameshot, bound to Mod+Shift+S in niri.kdl";

  config = lib.mkIf config.my.flameshot.enable {
    # Runs in the background (tray icon in waybar) so `flameshot gui` opens fast.
    # Captures through the Screenshot portal, which niri provides
    # (org.gnome.Shell.Screenshot behind xdg-desktop-portal-gnome).
    services.flameshot = {
      enable = true;
      settings.General = {
        inherit savePath;
        showStartupLaunchMessage = false;
      };
    };

    # Flameshot rejects a savePath that doesn't exist yet
    systemd.user.tmpfiles.rules = [ "d ${savePath} - - - -" ];
  };
}
