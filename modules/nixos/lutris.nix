{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.lutris.enable = lib.mkEnableOption "Lutris, for installing and running Windows games through Wine/Proton";

  # A NixOS module rather than a home one, like Steam (steam.nix): needs
  # 32-bit graphics drivers for the Wine/Proton prefixes it manages.
  config = lib.mkIf config.my.lutris.enable {
    hardware.graphics.enable32Bit = true; # also set by Steam; needed here too if Steam is off

    # Lets a running game ask for a performance CPU governor
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      lutris # bundles its own Wine/Proton runners (in ~/.local/share/lutris, already persisted)
      wineWow64Packages.stable # system-wide Wine (32+64bit), for winetricks and manual prefixes; cached, unlike the deprecated wineWowPackages
      winetricks
      gamescope # nested compositor; fixes fullscreen/alt-tab under niri for some games
      mangohud # FPS/perf overlay, opt-in per game
    ];

    environment.persistence.${config.my.impermanence.persistPath}.users.${config.my.user.name}.directories =
      [
        ".config/lutris" # installed games DB, runner and wine prefix settings
      ];
  };
}
