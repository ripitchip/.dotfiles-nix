# Secrets live encrypted in secrets/secrets.yaml (sops + age) and are decrypted
# at activation into /run/secrets, a ramfs: never in the Nix store nor in git.
#
#   nix shell nixpkgs#sops -c sops secrets/secrets.yaml   # edit
#
# The age key isn't in the repo: copy it to the same path on every new machine.
# https://github.com/Mic92/sops-nix
{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.secrets;
  user = config.my.user.name;
  home = "${config.my.impermanence.persistPath}/home/${user}";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.my.secrets.sshKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "id_ed25519" ];
    description = ''
      SSH key pairs installed in ~/.ssh, from the `ssh.<name>` and
      `ssh.<name>.pub` entries of secrets/secrets.yaml.
    '';
  };

  config = {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      # Read straight from the persistent disk: it must be there before the
      # impermanence bind mounts. Also where `sops` looks for it by default.
      age.keyFile = "${home}/.config/sops/age/keys.txt";

      secrets = {
        # Hash for the user and root (`mkpasswd -m yescrypt`), see core/users.nix
        password.neededForUsers = true;
      }
      // lib.listToAttrs (
        lib.concatMap (
          name:
          map
            (suffix: {
              name = "ssh/${name}${suffix}";
              value = {
                owner = user;
                mode = "0600";
                # Symlink in the persisted ~/.ssh, pointing to /run/secrets
                path = "${home}/.ssh/${name}${suffix}";
              };
            })
            [
              ""
              ".pub"
            ]
        ) cfg.sshKeys
      );
    };

    # So `sops` finds the key in ~/.config/sops/age without SOPS_AGE_KEY_FILE
    environment.persistence.${config.my.impermanence.persistPath}.users.${user}.files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
