{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.bitwarden.enable = lib.mkEnableOption "the Bitwarden desktop app and the `bw` CLI";

  config = lib.mkIf config.my.bitwarden.enable {
    home.packages = with pkgs; [
      bitwarden-cli
      bitwarden-desktop
    ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Bitwarden" # desktop app vault and login
      ".config/Bitwarden CLI" # bw session and cached vault
    ];
  };
}
