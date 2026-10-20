# ASUS ROG tools from https://asus-linux.org:
#   asusctl battery limit 80        stop charging at 80%
#   asusctl profile ...             same profiles as power-profiles-daemon
#   asusctl profile set -b Quiet    profile applied when unplugged (-a: on AC)
#   supergfxctl -m Hybrid           dGPU on demand, until reboot (log out to apply)
{ config, lib, ... }:
{
  options.my.asus.enable = lib.mkEnableOption "asusd (charge limit, profiles) and supergfxd (GPU modes) for ASUS ROG laptops";

  config = lib.mkIf config.my.asus.enable {
    services.asusd.enable = true;

    services.supergfxd = {
      enable = true;
      # Every field is required: supergfxd's defaults, except the mode
      settings = {
        mode = "Integrated"; # dGPU powered off, best battery
        vfio_enable = false;
        vfio_save = false;
        always_reboot = false;
        no_logind = false;
        logout_timeout_s = 180;
        hotplug_type = "None";
      };
    };

    # charge limit, profile, ...
    environment.persistence.${config.my.impermanence.persistPath}.directories = [ "/etc/asusd" ];
  };
}
