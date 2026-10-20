{ config, lib, ... }:
{
  options.my.neovim.enable = lib.mkEnableOption "neovim as the default editor";

  config = lib.mkIf config.my.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
