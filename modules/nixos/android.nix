{ config, lib, ... }:
{
  options.my.android.enable = lib.mkEnableOption "Android development: hardware-accelerated emulator access";

  # A NixOS module rather than a home one: the emulator needs KVM to run
  # system images at a usable speed, and group membership for /dev/kvm can
  # only be granted at the system level. Android Studio and Flutter
  # themselves are installed through home-manager (modules/home/android-studio.nix,
  # modules/home/flutter.nix).
  config = lib.mkIf config.my.android.enable {
    users.users.${config.my.user.name}.extraGroups = [ "kvm" ];
  };
}
