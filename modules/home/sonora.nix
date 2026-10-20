{
  config,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [ inputs.sonora.homeManagerModules.default ];

  options.my.sonora.enable = lib.mkEnableOption "the Sonora music player";

  config = lib.mkIf config.my.sonora.enable {
    # Prebuilt release on x86_64-linux, see the sonora flake
    programs.sonora.enable = true;

    # state.sqlite and the log live in ~/.local/{share,state}, already persisted
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/sonora" # custom themes
      # subsonic/credentials.json holds the server login; also the library
      # cache and cover art, so they aren't fetched again after a reboot
      ".cache/sonora"
    ];
  };
}
