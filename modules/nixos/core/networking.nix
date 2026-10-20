{ config, ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  users.users.${config.my.user.name}.extraGroups = [ "networkmanager" ];

  environment.persistence.${config.my.impermanence.persistPath}.directories = [
    "/etc/NetworkManager/system-connections" # saved Wi-Fi networks
  ];
}
