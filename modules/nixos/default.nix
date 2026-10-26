# Every module here declares options under `my.*`. Core modules are always
# active and only expose settings; feature modules are off until a host sets
# `my.<feature>.enable = true`.
{
  imports = [
    ./core
    ./android.nix
    ./asus.nix
    ./audio.nix
    ./bluetooth.nix
    ./desktop.nix
    ./docker.nix
    ./impermanence.nix
    ./laptop.nix
    ./nvidia.nix
    ./sdr.nix
    ./secrets.nix
    ./steam.nix
  ];
}
