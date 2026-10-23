# home-manager modules, all off by default; enabled per user in home/<user>.nix.
# Each feature module owns everything it needs: packages, config, persisted state.
{
  imports = [
    ./aerc.nix
    ./android-studio.nix
    ./bitwarden.nix
    ./claude-desktop.nix
    ./desktop
    ./firefox.nix
    ./flameshot.nix
    ./flutter.nix
    ./git
    ./helium.nix
    ./impermanence.nix
    ./jellyfin.nix
    ./kubernetes.nix
    ./neovim.nix
    ./nocturne.nix
    ./opencloud-desktop.nix
    ./protonmail.nix
    ./sable.nix
    ./shell.nix
    ./signal.nix
    ./sonora.nix
    ./termsonic.nix
    ./vscode.nix
    ./zen-browser.nix
    ./zellij.nix
  ];
}
