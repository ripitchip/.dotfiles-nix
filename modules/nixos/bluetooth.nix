{ config, lib, ... }:
{
  options.my.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf config.my.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    environment.persistence.${config.my.impermanence.persistPath}.directories = [
      "/var/lib/bluetooth" # paired devices
    ];
  };
}
