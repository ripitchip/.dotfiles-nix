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

    # The package only ships its icon under share/pixmaps, which GTK finds
    # but strict icon-theme lookups (waybar's taskbar, fuzzel, niri's window
    # switcher) don't check, so they fall back to a generic icon. Registering
    # it under hicolor makes "Icon=proton-mail" in the .desktop file resolve
    # everywhere.
    xdg.dataFile."icons/hicolor/512x512/apps/proton-mail.png".source =
      "${pkgs.protonmail-desktop}/share/proton-mail/icon.png";

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Proton Mail" # login and cache
    ];
  };
}
