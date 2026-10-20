{ config, lib, ... }:
{
  options.my.shell.enable = lib.mkEnableOption "zsh with fzf";

  config = lib.mkIf config.my.shell.enable {
    programs.zsh = {
      enable = true;
      # Keep ~ clean: .zshrc & co. live in ~/.config/zsh
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      # Vi mode: Esc switches to command mode (Starship shows ❮)
      defaultKeymap = "viins";
      # No terminal bell on failed completion, bad history search, ...
      setOptions = [ "NO_BEEP" ];

      # Ctrl+X Ctrl+E: edit the command line in $EDITOR (nvim), `:wq` to return
      initContent = ''
        # Alt+Backspace sends Esc then Backspace: delete a word instead of
        # entering command mode. Plain Backspace may also delete text typed
        # before the last Esc (vi-backward-delete-char stops there).
        bindkey -M viins '^[^?' backward-kill-word '^[^H' backward-kill-word
        bindkey -M viins '^?' backward-delete-char '^H' backward-delete-char

        # Usual emacs keys in insert mode (vi's viins leaves them unbound)
        bindkey -M viins '^A' beginning-of-line '^E' end-of-line
        bindkey -M viins '^K' kill-line '^U' backward-kill-line '^W' backward-kill-word
        bindkey -M viins '^[b' backward-word '^[f' forward-word

        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^X^E' edit-command-line
      '';

      history = {
        # In ~/.local/share, which is persisted. Bind-mounting a single history
        # file breaks because zsh rewrites it by renaming a new file over it.
        path = "${config.xdg.dataHome}/zsh/history";
        size = 50000;
        save = 50000;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = true;
      };
    };

    # Each of these hooks into zsh automatically
    programs.fzf.enable = true;

    # Default Starship prompt
    programs.starship.enable = true;
  };
}
