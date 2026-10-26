{
  config,
  lib,
  inputs,
  osConfig,
  pkgs,
  ...
}:
let
  # There's no native Android Messages desktop client: run messages.google.com
  # as a site-specific app in its own Helium (chromium) window and profile,
  # same browser engine already packaged for modules/home/helium.nix.
  # Same fix as helium.nix: keep the session/cookies in the Secret Service
  # (oo7, see modules/nixos/desktop.nix) instead of plain text.
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium.override {
    flags = [ "--password-store=gnome-libsecret" ];
  };

  profileDir = "${config.home.homeDirectory}/.config/android-messages";
in
{
  options.my.android-messages.enable = lib.mkEnableOption "Android Messages (messages.google.com) as a site-specific app";

  config = lib.mkIf config.my.android-messages.enable {
    home.packages = [ helium ];

    xdg.desktopEntries.android-messages = {
      name = "Android Messages";
      comment = "Send and receive SMS from the desktop";
      icon = "android-messages";
      exec = "${helium}/bin/helium --app=https://messages.google.com/web --user-data-dir=${profileDir} --class=android-messages";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      settings.StartupWMClass = "android-messages";
    };

    xdg.dataFile."icons/hicolor/scalable/apps/android-messages.svg".source = ./android-messages.svg;

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/android-messages" # browser profile: phone pairing, session, cookies
    ];
  };
}
