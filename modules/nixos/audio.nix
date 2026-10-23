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
      wireplumber = {
        enable = true;
        # SBC-XQ (a higher, non-standard SBC bitpool for better quality) is on by
        # default; some A2DP sinks accept the connection and report it as active
        # but their decoder silently produces no audio with it. Hit this with a
        # "sonoro Stream" speaker: paired, AVRCP (track info) worked, zero sound.
        #
        # Disabling sbc-xq alone wasn't enough for the Stream: a btsnoop capture
        # showed PipeWire still negotiating 48kHz/bitpool-58 SBC, while a phone
        # pairing to the same speaker (which plays fine) negotiates 44.1kHz/
        # bitpool-53 -- the Stream's BT 4.0 decoder apparently can't handle the
        # 48kHz config and just outputs silence instead of erroring. Forcing the
        # A2DP rate to 44100 matches what the phone uses.
        extraConfig."51-bluez-no-sbc-xq" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = false;
            "bluez5.default.rate" = 44100;
          };
        };
      };
    };

    # TUI mixer talking to PipeWire directly
    environment.systemPackages = [ pkgs.wiremix ];
  };
}
