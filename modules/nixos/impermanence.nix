# / is a tmpfs: everything not listed in a persistence entry is wiped on reboot.
# Feature modules add their own paths to
# `environment.persistence.${config.my.impermanence.persistPath}` (home modules:
# `home.persistence`, see modules/home/impermanence.nix).
# https://github.com/nix-community/impermanence#module-usage
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.my.impermanence = {
    enable = lib.mkEnableOption "persisting selected state on a tmpfs root";
    persistPath = lib.mkOption {
      type = lib.types.str;
      default = "/nix/persist";
      description = "Directory on a persistent filesystem where state is kept.";
    };
  };

  # mkDefault: if / was a tmpfs at install time, nixos-generate-config also
  # writes this mount, and that one wins
  config.fileSystems."/" = lib.mkIf cfg.enable (
    lib.mkDefault {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=25%"
        "mode=755"
      ];
    }
  );

  # /tmp as its own tmpfs, with its own budget, instead of living inside /.
  # Otherwise any directory that fills up the root tmpfs (e.g. a big
  # extraction under $HOME, since / is wiped on reboot anyway) starves /tmp
  # too, breaking anything that writes there — Nix's sqlite db included.
  config.boot.tmp = lib.mkIf cfg.enable {
    useTmpfs = lib.mkDefault true;
    tmpfsSize = lib.mkDefault "50%";
  };

  config.environment.persistence.${cfg.persistPath} = {
    inherit (cfg) enable;
    hideMounts = true;

    directories = [
      "/var/lib/nixos" # uid/gid maps
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers" # so weekly timers don't all fire on every boot
    ];

    files = [
      # Stable machine-id keeps `journalctl --boot=-1` working across reboots
      "/etc/machine-id"
    ];

    users.${config.my.user.name} = {
      directories = [
        ".dotfiles"

        # XDG data/state: shell history, nvim undo, ...
        ".local/share"
        ".local/state"

        # App state (~/.config/mozilla, ...) is persisted by each module in
        # modules/home, through home.persistence

        ".claude"

        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".gnupg";
          mode = "0700";
        }

        "desktop"
        "documents"
        "downloads"
        "music"
        "pictures"
        "projects"
        "videos"
      ];

      files = [
        ".claude.json"
        ".bash_history"
      ];
    };
  };
}
