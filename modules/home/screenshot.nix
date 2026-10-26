# Flameshot's "gui" mode needs the Screenshot portal, which goes through
# niri's org.gnome.Shell.Screenshot compatibility shim; that shim only
# supports a single output and errors out with 2 monitors connected
# (`Condition failed: outputs.len() == 1`), so the capture never starts.
# grim+slurp+swappy bypass the portal entirely (grim talks to the
# compositor's own wlr-screencopy protocol directly), so they're unaffected.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  savePath = "${config.home.homeDirectory}/pictures/screenshots";
in
{
  options.my.screenshot.enable = lib.mkEnableOption "grim+slurp+swappy screenshot/annotate, bound to Mod+Shift+S in niri.kdl";

  config = lib.mkIf config.my.screenshot.enable {
    home.packages = [
      pkgs.grim # capture
      pkgs.slurp # region selection
      # swappy's paint-mode toolbar (brush/text/rectangle/...) renders its
      # icons as glyphs from this exact font (res/style/swappy.css
      # upstream), not from the system icon theme; without it those
      # buttons show empty boxes.
      pkgs.font-awesome_5
    ];

    programs.swappy = {
      enable = true;
      settings.Default = {
        save_dir = savePath;
        save_filename_format = "screenshot-%Y%m%d-%H%M%S.png";
      };
    };

    systemd.user.tmpfiles.rules = [ "d ${savePath} - - - -" ];
  };
}
