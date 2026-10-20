# NVIDIA proprietary driver, for a desktop whose screens are plugged into the
# NVIDIA card (the Intel iGPU stays unused: no PRIME offload needed).
{ config, lib, ... }:
{
  options.my.nvidia.enable = lib.mkEnableOption "the NVIDIA proprietary driver";

  config = lib.mkIf config.my.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ]; # also used under Wayland

    hardware.nvidia = {
      modesetting.enable = true; # required by Wayland compositors
      # Open kernel modules: RTX 20xx / GTX 16xx and newer only, set to false
      # for older cards
      open = true;
    };

    # niri keeps gigabytes of VRAM in the driver's buffer pool without this
    # https://github.com/YaLTeR/niri/wiki/Nvidia
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      builtins.toJSON {
        rules = [
          {
            pattern = {
              feature = "procname";
              matches = "niri";
            };
            profile = "Limit Free Buffer Pool On Wayland Compositors";
          }
        ];
        profiles = [
          {
            name = "Limit Free Buffer Pool On Wayland Compositors";
            settings = [
              {
                key = "GLVidHeapReuseRatio";
                value = 0;
              }
            ];
          }
        ];
      };
  };
}
