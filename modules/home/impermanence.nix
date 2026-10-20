# Home modules persist their own state next to their config, like system
# modules do with environment.persistence:
#
#   home.persistence.${osConfig.my.impermanence.persistPath}.directories = [ ".config/foo" ];
#
# Paths are relative to $HOME; the NixOS impermanence module merges them with
# the system list, so this only follows the system settings.
{ osConfig, ... }:
let
  cfg = osConfig.my.impermanence;
in
{
  home.persistence.${cfg.persistPath} = {
    inherit (cfg) enable;
    hideMounts = true;
  };
}
