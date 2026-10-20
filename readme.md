# dotfiles

Configuration NixOS (flake) + home-manager du laptop et du PC fixe, avec `/`
en tmpfs ([impermanence](https://github.com/nix-community/impermanence)) et le
compositeur [niri](https://github.com/YaLTeR/niri).

## Structure

```
flake.nix                 entrées + une nixosConfiguration par dossier de hosts/
hosts/common.nix          commun à toutes les machines (utilisateur, home-manager, firmware)
secrets/secrets.yaml      secrets chiffrés (sops), voir .sops.yaml
hosts/<host>/             spécifique à la machine (matériel, hostname, features, stateVersion)
modules/nixos/            modules système (boot, nix, desktop, réseau, users, persistance, ...)
modules/home/             modules home-manager (shell, git, neovim, apps, ...)
home/                     profil home-manager de chaque utilisateur
```

Machines : `laptop` (ASUS ROG Flow X13), `desktop` (PC fixe, NVIDIA + iGPU Intel).

## Utilisation

```sh
sudo nixos-rebuild switch --flake ~/.dotfiles#laptop   # rebuild + activer
sudo nixos-rebuild boot --flake ~/.dotfiles#laptop     # activer au prochain reboot
nix flake update                                       # mettre à jour flake.lock (sans sudo)
nix fmt                                                # formater tous les fichiers .nix
nix flake check                                        # vérifier que tout évalue
```

## Options

Chaque module déclare ses options sous `my.*`. Les modules `core/` sont
toujours actifs ; les autres s'activent par machine dans `hosts/<host>/default.nix`
(`my.audio.enable = true;`, ...) ou par utilisateur dans `home/<user>.nix`.

Pour changer une app home-manager sur une seule machine, dans
`hosts/<host>/default.nix` :

```nix
home-manager.users.thomas.my.signal.enable = lib.mkForce false;
```

## Nouvelle machine

Même schéma de disques sur chaque machine : ESP sur `/boot`, LUKS + ext4 sur
`/nix` (l'état persistant est dans `/nix/persist`), `/` en tmpfs (monté par
`modules/nixos/impermanence.nix`).

Depuis l'ISO NixOS, une fois les partitions créées :

```sh
cryptsetup luksFormat /dev/<partition-nix>
cryptsetup open /dev/<partition-nix> crypted
mkfs.ext4 /dev/mapper/crypted
mkfs.fat -F 32 /dev/<partition-esp>

mount -t tmpfs -o mode=755 none /mnt
mkdir -p /mnt/{boot,nix}
mount /dev/mapper/crypted /mnt/nix
mount -o umask=0077 /dev/<partition-esp> /mnt/boot
mkdir -p /mnt/nix/persist/home/thomas/.config/sops/age
# copier la clé age (voir Secrets) dans ce dossier

git clone <ce repo> /mnt/nix/persist/home/thomas/.dotfiles
cd /mnt/nix/persist/home/thomas/.dotfiles
nixos-generate-config --root /mnt --show-hardware-config > hosts/<host>/hardware-configuration.nix
git add -A
nixos-install --flake .#<host> --no-root-passwd
chown -R 1000:100 /mnt/nix/persist/home/thomas
```

Pour une machine de plus : copier `hosts/desktop/`, l'ajouter dans
`flake.nix` et choisir ses `my.*.enable`.

## Persistance

Tout ce qui n'est pas persisté est effacé au reboot. L'état de base (logs,
`~/.ssh`, dossiers XDG, ...) est listé dans `modules/nixos/impermanence.nix` ;
chaque module persiste lui-même l'état de son appli, à côté de sa config :
`environment.persistence` côté NixOS, `home.persistence` côté home-manager
(ex. `modules/home/bitwarden.nix`).

Pour savoir ce qu'une appli écrit hors persistance :

```sh
sudo find / -xdev -newer /etc/machine-id -type f 2>/dev/null | grep -v '^/nix\|^/proc'
```

## Secrets

Mot de passe et clés SSH sont chiffrés dans `secrets/secrets.yaml`
([sops-nix](https://github.com/Mic92/sops-nix) + age), déchiffrés au boot dans
`/run/secrets` (en RAM). La clé age n'est pas dans le repo :
`/nix/persist/home/thomas/.config/sops/age/keys.txt`, **à sauvegarder** (sans
elle plus de mot de passe : impossible de se connecter) et à copier au même
endroit sur chaque nouvelle machine avant `nixos-install`.

```sh
nix shell nixpkgs#sops -c sops secrets/secrets.yaml   # éditer les secrets
```

Mot de passe : `password` dans les secrets, un hash généré avec
`nix run nixpkgs#mkpasswd -- -m yescrypt` (les utilisateurs sont immuables,
`passwd` ne sert à rien).

Clés SSH : ajouter `ssh.<nom>` (clé privée) et `ssh.<nom>.pub` dans les
secrets, puis `<nom>` dans `my.secrets.sshKeys` (`hosts/common.nix`). Elles
apparaissent dans `~/.ssh` comme liens vers `/run/secrets`.
