{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Bound to Mod+Shift+D in niri.kdl: pick a command from $PATH (or type one
  # with arguments) and run it in kitty, which stays on a shell afterwards
  command-run = pkgs.writeShellApplication {
    name = "command-run";
    runtimeInputs = [
      pkgs.findutils
      config.programs.fuzzel.package
      config.programs.kitty.package
    ];
    # A missing PATH dir or broken symlink must not fail the pipeline (pipefail).
    # Escape makes fuzzel fail: stop there instead of opening an empty shell
    text = ''
      cmd=$(
        IFS=:
        for dir in $PATH; do
          find -L "$dir" -maxdepth 1 -type f -executable -printf '%f\n' 2>/dev/null || true
        done | sort -u \
          | fuzzel --dmenu --prompt "run ❯ " --placeholder "Search commands…"
      ) || exit 0
      exec kitty zsh -ic "$cmd; exec zsh"
    '';
  };
in
{
  config = lib.mkIf config.my.desktop.enable {
    home.packages = [ command-run ];

    # App launcher, bound to Mod+D in niri.kdl
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          # Terminal apps (Terminal=true in their .desktop) open in kitty
          terminal = "kitty";
          font = "Iosevka:size=14";
          # With every output at scale 1, "auto" sizes fonts from the panel's
          # real DPI (~168 on eDP-1) and the whole launcher looks zoomed in.
          # "no" sizes them for 96 DPI, like waybar and kitty
          dpi-aware = "no";
          prompt = "\"❯ \"";
          placeholder = "Search apps…";
          layer = "overlay";
          width = 40; # in characters
          lines = 8;
          horizontal-pad = 24;
          vertical-pad = 16;
          inner-pad = 12;
          line-height = 28;
          image-size-ratio = 0; # no big preview icon above the list
          # Launch counts that rank frequent apps first: in ~/.local/state,
          # which is persisted, rather than the default ~/.cache/fuzzel
          cache = "${config.xdg.stateHome}/fuzzel";
        };

        # RRGGBBAA; accent matches the niri focus ring (#7fc8ff)
        colors = {
          background = "16161ef2";
          text = "c8ccd4ff";
          prompt = "7fc8ffff";
          placeholder = "5c6370ff";
          input = "e6e6e6ff";
          match = "7fc8ffff";
          selection = "2a2f3aff";
          selection-text = "ffffffff";
          selection-match = "7fc8ffff";
          counter = "5c6370ff";
          border = "7fc8ff99";
        };

        border = {
          width = 2;
          radius = 12;
        };
      };
    };
  };
}
