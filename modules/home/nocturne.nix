{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.my.nocturne.enable = lib.mkEnableOption "Nocturne, an Adwaita music player for OpenSubsonic servers like Navidrome";

  config = lib.mkIf config.my.nocturne.enable {
    # Password in the Secret Service (oo7, see modules/nixos/desktop.nix);
    # downloads and lyrics in ~/.local/share/com.jeffser.Nocturne, already persisted
    home.packages = [ pkgs.nocturne ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/com.jeffser.Nocturne" # device_id
      ".cache/com.jeffser.Nocturne" # library cache, not fetched again after a reboot
      # Settings, server URL and user are GSettings keys. home-manager's
      # dconf.settings only overwrite the keys they set, so the rest survive.
      ".config/dconf"
    ];
  };
}
