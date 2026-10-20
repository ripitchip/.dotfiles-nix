{ config, lib, ... }:
{
  options.my.steam.enable = lib.mkEnableOption "Steam";

  # A NixOS module rather than a home one: Steam needs 32-bit graphics drivers
  # and udev rules for controllers. Games and login live in ~/.local/share/Steam,
  # already persisted; ~/.steam only holds symlinks Steam recreates on start.
  config = lib.mkIf config.my.steam.enable {
    programs.steam.enable = true; # also sets hardware.graphics.enable32Bit
  };
}
