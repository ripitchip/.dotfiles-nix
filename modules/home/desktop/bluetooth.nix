{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.desktop.enable {
    # GUI for pairing/connecting devices (waybar just shows status).
    # Bound to Mod+Shift+B in niri.kdl, and opened by clicking waybar's bluetooth module.
    home.packages = [ pkgs.overskride ];

    # BlueZ doesn't auto-detect MPRIS players; it only exposes a Media1.RegisterPlayer
    # D-Bus call that something has to invoke. GNOME/KDE do this themselves; on niri
    # nothing does, so a connected speaker never gets track info or a play state and
    # (on some speakers) stays silent. mpris-proxy (shipped with bluez) bridges the
    # active MPRIS session (e.g. Sonora) to BlueZ/AVRCP.
    systemd.user.services.mpris-proxy = {
      Unit = {
        Description = "Bluetooth MPRIS proxy";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
