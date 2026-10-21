{
  config,
  lib,
  osConfig,
  ...
}:
let
  # Installed from addons.mozilla.org and kept up to date by Firefox
  extension = slug: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
    installation_mode = "force_installed";
  };
in
{
  options.my.firefox.enable = lib.mkEnableOption "Firefox with the Bitwarden, Proton VPN and uBlock Origin extensions";

  config = lib.mkIf config.my.firefox.enable {
    # Only policies are declared: the profile itself (settings, bookmarks, ...)
    # is left to Firefox and persisted below
    programs.firefox = {
      enable = true;
      policies = {
        # Extension IDs: see "guid" at https://addons.mozilla.org/api/v5/addons/addon/<slug>/
        ExtensionSettings = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = extension "bitwarden-password-manager";
          "vpn@proton.ch" = extension "proton-vpn-firefox-extension";
          "uBlock0@raymondhill.net" = extension "ublock-origin";
        };

        # Reopen the tabs of the previous session on startup
        Homepage = {
          StartPage = "previous-session";
          Locked = false;
        };

        # "default" only changes the default value: still adjustable in the settings
        Preferences = {
          "sidebar.revamp" = {
            Value = true;
            Status = "default";
          };
          "sidebar.verticalTabs" = {
            Value = true;
            Status = "default";
          };
        };
      };
    };

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/mozilla" # profile location since Firefox 147
    ];
  };
}
