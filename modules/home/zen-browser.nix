{
  config,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  # Stable releases; the module is home-manager's Firefox one, so `policies`
  # works as in firefox.nix
  imports = [ inputs.zen-browser.homeModules.beta ];

  options.my.zen-browser.enable = lib.mkEnableOption "Zen, a Firefox-based browser";

  config = lib.mkIf config.my.zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/zen" # profile: settings, bookmarks, extensions, sessions
    ];
  };
}
