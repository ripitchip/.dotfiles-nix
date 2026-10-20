# Shared by every host: the main user and their home-manager profile.
# Hosts import this, then pick their features and hardware.
{ config, ... }:
{
  imports = [ ../modules/nixos ];

  my.user = {
    name = "thomas";
    fullName = "Thomas DERUDDER";
    email = "thomas@tomlab.fr";
  };

  # Private keys from secrets/secrets.yaml, same on every host
  my.secrets.sshKeys = [
    "id_rsa"
    "id_rsa_2"
  ];

  home-manager.users.${config.my.user.name} = ../home/thomas.nix;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
}
