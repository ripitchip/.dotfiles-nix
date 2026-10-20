{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.laptop.enable = lib.mkEnableOption "laptop power management and backlight control";

  config = lib.mkIf config.my.laptop.enable {
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl
      acpi # `acpi -bt`: battery, AC adapter, temperatures
    ];

    environment.persistence.${config.my.impermanence.persistPath}.directories = [
      "/var/lib/power-profiles-daemon" # last selected profile
    ];
  };
}
