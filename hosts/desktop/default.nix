# Desktop PC: NVIDIA GPU + Intel iGPU
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "desktop";

  my = {
    android.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
    desktop.enable = true;
    docker.enable = true;
    impermanence.enable = true;
    nvidia.enable = true;
    printing.enable = true;
    sdr.enable = true;
    steam.enable = true;
  };

  # Set to the NixOS release at install time, then never change it
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
