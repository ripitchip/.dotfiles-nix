{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.jellyfin.enable = lib.mkEnableOption "Jellyfin Media Player, the official desktop client for a Jellyfin server";

  config = lib.mkIf config.my.jellyfin.enable {
    home.packages = [ pkgs.jellyfin-media-player ];

    # Server URL, login and per-profile settings live under
    # ~/.local/share/jellyfin-desktop/profiles/<id>/ (jellyfin-desktop.conf);
    # its cache (library/image cache) is under ~/.cache/jellyfin-desktop/.
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".local/share/jellyfin-desktop"
      ".cache/jellyfin-desktop"
    ];
  };
}
