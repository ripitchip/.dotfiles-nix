{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.desktop.enable {
    # GUI for pairing/connecting devices (waybar just shows status).
    # Bound to Mod+Shift+B in niri.kdl, and opened by clicking waybar's bluetooth module.
    home.packages = [ pkgs.overskride ];
  };
}
