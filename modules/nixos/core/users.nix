{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.my.user;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Login name of the main user.";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Full name, used for git and the account description.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address, used for git.";
    };
  };

  config = {
    # Users are fully declared here; / is wiped on every boot anyway
    users.mutableUsers = false;

    users.users = {
      # Hash from secrets/secrets.yaml, see modules/nixos/secrets.nix
      root.hashedPasswordFile = config.sops.secrets.password.path;

      ${cfg.name} = {
        isNormalUser = true;
        uid = 1000;
        description = cfg.fullName;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets.password.path;
      };
    };

    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      # Our home-manager modules, available to every user profile
      sharedModules = [ ../../home ];
      # Move conflicting files aside instead of failing the activation
      backupFileExtension = "hm-backup";
    };
  };
}
