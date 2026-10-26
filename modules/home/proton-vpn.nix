{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.proton-vpn.enable = lib.mkEnableOption "the Proton VPN desktop app";

  config = lib.mkIf config.my.proton-vpn.enable {
    home.packages = [ pkgs.proton-vpn ];

    # proton-keyring-linux talks to the Secret Service (oo7, see
    # modules/nixos/desktop.nix) directly, no password-store flag needed
    # like some Electron apps.
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Proton" # session, settings
      ".cache/Proton" # logs
    ];

    # Autostart minimised to the tray with the session instead of relying on
    # a manual launch (same approach as opencloud). The VPN connection itself
    # is a regular NetworkManager profile once established, so it survives
    # even if this process gets killed — this unit only gets it running and
    # out of the way on login.
    systemd.user.services.proton-vpn = {
      Unit = {
        Description = "Proton VPN desktop app";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.proton-vpn}/bin/protonvpn-app --start-minimized";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
