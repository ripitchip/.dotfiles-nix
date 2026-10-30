{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.obs.enable = lib.mkEnableOption "OBS Studio, for screen recording and streaming";

  config = lib.mkIf config.my.obs.enable {
    home.packages = [ pkgs.obs-studio ];

    # Scenes, profiles and plugin config live here; logs/crashes in
    # ~/.config/obs-studio/{logs,crashes} are left out, not worth persisting.
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/obs-studio"
    ];
  };
}
