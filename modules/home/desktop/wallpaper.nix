{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.desktop.enable {
    # GUI wallpaper picker; which image is set is picked interactively and
    # cached in its own ~/.config/waypaper, so changing the wallpaper never
    # needs a Nix change or a commit. awww must be on PATH too: waypaper
    # detects the backend with `shutil.which("awww")` and shells out to the
    # `awww` CLI, not just the daemon below.
    home.packages = [
      pkgs.waypaper
      pkgs.awww
    ];

    # waypaper's "awww" backend (awww is swww's successor) needs its daemon
    # already running to set/restore the wallpaper.
    systemd.user.services.awww-daemon = {
      Unit = {
        Description = "Wallpaper daemon (awww)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
