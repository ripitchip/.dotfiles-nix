{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.git;
in
{
  options.my.git = {
    enable = lib.mkEnableOption "git";
    userName = lib.mkOption {
      type = lib.types.str;
      description = "Name used for commits.";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email used for commits.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        diff.algorithm = "histogram";
      };
    };

    # Key from secrets/secrets.yaml, see my.secrets.sshKeys
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_rsa";
        IdentitiesOnly = true;
      };
    };

    # Not programs.lazygit: it generates config.yml from `settings` and would
    # conflict with this file
    home.packages = [ pkgs.lazygit ];
    xdg.configFile."lazygit/config.yml".source = ./lazygit.yml;
  };
}
