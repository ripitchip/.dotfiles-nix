{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.android-studio.enable = lib.mkEnableOption "Android Studio, the Android SDK, and the emulator";

  # KVM access for the hardware-accelerated emulator is granted in
  # modules/nixos/android.nix (needs my.android.enable on the host too).
  config = lib.mkIf config.my.android-studio.enable {
    home.packages = with pkgs; [
      android-studio
      jdk21 # for Gradle builds; Android Studio bundles its own JBR for itself
      android-tools # adb, fastboot, ... on PATH without going through the SDK Manager
    ];

    # SDK components, platforms, build-tools, the emulator and system images
    # are fetched through Android Studio's SDK Manager on first run (License
    # acceptance happens there too), into ANDROID_HOME below.
    home.sessionVariables = {
      ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
      ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
      JAVA_HOME = pkgs.jdk21.home;
    };

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      "Android/Sdk" # platforms, build-tools, emulator + system images
      ".android" # AVD configs, debug.keystore, adb key
      ".config/Google" # Android Studio settings (plugins/local history already covered by the broad ~/.local/share persistence)
      ".gradle" # wrapper + dependency cache, also used by Flutter's Android builds
    ];
  };
}
