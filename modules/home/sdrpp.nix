# SDR++, built with SDRplay (RSP) support. The driver/udev setup lives in
# modules/nixos/sdr.nix; this just needs that enabled on the host.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.sdrpp.enable = lib.mkEnableOption "SDR++, a cross-platform SDR receiver, with SDRplay support";

  config = lib.mkIf config.my.sdrpp.enable {
    home.packages = [ (pkgs.sdrpp.override { sdrplay_source = true; }) ];

    # The API service sdrplay_source talks to over a local socket. The udev
    # rules in modules/nixos/sdr.nix grant device access without root, so
    # this can run as a normal user service rather than system-wide.
    systemd.user.services.sdrplay-api = {
      Unit = {
        Description = "SDRplay API service";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.sdrplay}/bin/sdrplay_apiService";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
