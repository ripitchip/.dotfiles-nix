{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.protonmail.enable = lib.mkEnableOption "the Proton Mail desktop app as the default mail client";

  config = lib.mkIf config.my.protonmail.enable {
    home.packages = [ pkgs.protonmail-desktop ];

    # mailto: links open the app
    xdg.mimeApps = {
      enable = true;
      defaultApplications."x-scheme-handler/mailto" = "proton-mail.desktop";
    };

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Proton Mail" # login and cache
    ];
  };
}
