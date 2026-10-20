{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Bound to Mod+C in niri.kdl: search the history, copy the pick back
  clipboard-pick = pkgs.writeShellApplication {
    name = "clipboard-pick";
    runtimeInputs = with pkgs; [
      cliphist
      fuzzel
      wl-clipboard
    ];
    # cliphist lines are "<id>\t<preview>": show and search the preview only.
    # Escape makes fuzzel fail: stop there instead of copying an empty string
    text = ''
      pick=$(cliphist list \
        | fuzzel --dmenu --prompt "clip ❯ " --placeholder "Search clipboard…" \
            --with-nth 2 --match-nth 2 --width 60) || exit 0
      cliphist decode <<<"$pick" | wl-copy
    '';
  };
in
{
  config = lib.mkIf config.my.desktop.enable {
    # Stores every copy (text and images) in ~/.cache/cliphist, which is not
    # persisted: the history, passwords included, is gone after a reboot
    services.cliphist.enable = true;

    home.packages = [ clipboard-pick ];
  };
}
