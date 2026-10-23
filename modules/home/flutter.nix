{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.flutter.enable = lib.mkEnableOption "the Flutter SDK";

  # Building/running on Android also needs my.android-studio.enable, for the
  # SDK, platform-tools and emulator Flutter shells out to.
  config = lib.mkIf config.my.flutter.enable {
    home.packages = [ pkgs.flutter ];

    # Don't `flutter upgrade`: the SDK is the one nixpkgs pins, updated via
    # the flake instead.
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".pub-cache" # downloaded packages, shared across all projects
    ];
  };
}
