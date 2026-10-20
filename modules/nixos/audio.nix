{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.audio.enable = lib.mkEnableOption "PipeWire audio and the wiremix mixer";

  config = lib.mkIf config.my.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # TUI mixer talking to PipeWire directly
    environment.systemPackages = [ pkgs.wiremix ];
  };
}
