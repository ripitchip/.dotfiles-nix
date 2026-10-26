{ config, lib, ... }:
{
  options.my.docker.enable = lib.mkEnableOption "Docker";

  # A NixOS module rather than a home one: the daemon and group membership
  # for /var/run/docker.sock can only be granted at the system level.
  config = lib.mkIf config.my.docker.enable {
    virtualisation.docker.enable = true;

    users.users.${config.my.user.name}.extraGroups = [ "docker" ];

    # Images/containers live in /var/lib/docker; / is a tmpfs, so without this
    # they'd vanish on every reboot.
    environment.persistence.${config.my.impermanence.persistPath}.directories = [
      "/var/lib/docker"
    ];
  };
}
