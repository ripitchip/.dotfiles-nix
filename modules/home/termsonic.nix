{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.termsonic.enable = lib.mkEnableOption "termsonic, a Subsonic/Navidrome client in the terminal";

  config = lib.mkIf config.my.termsonic.enable {
    home.packages = [ pkgs.termsonic ];

    # Server URL and login, entered in termsonic's config tab (F4).
    # Kept out of the Nix store: the password is stored in plain text.
    home.persistence.${osConfig.my.impermanence.persistPath}.files = [ ".config/termsonic.toml" ];
  };
}
