# ASUS ROG Flow X13
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "laptop";

  my = {
    asus.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
    desktop.enable = true;
    impermanence.enable = true;
    laptop.enable = true;
    steam.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
