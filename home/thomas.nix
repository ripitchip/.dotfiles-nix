# Thomas's home: picks which modules/home features are on.
# home.username / home.homeDirectory are set by the NixOS home-manager module.
{
  config,
  osConfig,
  pkgs,
  ...
}:
{
  my = {
    shell.enable = true;
    aerc.enable = true;
    neovim.enable = true;
    zellij.enable = config.my.desktop.enable;
    kubernetes.enable = true;
    git = {
      enable = true;
      userName = "ripitchip";
      userEmail = osConfig.my.user.email;
    };
    # Follow the system: no niri session nor GUI apps on a machine without niri
    desktop.enable = osConfig.my.desktop.enable;
    firefox.enable = config.my.desktop.enable;
    screenshot.enable = config.my.desktop.enable;
    bitwarden.enable = config.my.desktop.enable;
    claude-desktop.enable = config.my.desktop.enable;
    protonmail.enable = config.my.desktop.enable;
    signal.enable = config.my.desktop.enable;
    sonora.enable = config.my.desktop.enable;
    nocturne.enable = config.my.desktop.enable;
    opencloud-desktop.enable = config.my.desktop.enable;
    sable.enable = config.my.desktop.enable;
    sdrpp.enable = osConfig.my.sdr.enable;
    termsonic.enable = osConfig.my.audio.enable;
    vscode.enable = config.my.desktop.enable;
    zen-browser.enable = config.my.desktop.enable;
    helium.enable = config.my.desktop.enable;
    jellyfin.enable = config.my.desktop.enable;
    android-studio.enable = config.my.desktop.enable;
    flutter.enable = config.my.desktop.enable;
  };

  # Password in the oo7 keyring, unlocked at login:
  #   oo7-cli store 'SFR mail' service=mail account=sfr
  accounts.email.accounts.sfr = {
    primary = true;
    address = "thomasderudder@sfr.fr";
    userName = "thomasderudder@sfr.fr";
    realName = osConfig.my.user.fullName;
    imap = {
      host = "imap.sfr.fr";
      port = 993;
    };
    smtp = {
      host = "smtp.sfr.fr";
      port = 465;
    };
    passwordCommand = [
      "oo7-cli"
      "lookup"
      "--secret-only"
      "service=mail"
      "account=sfr"
    ];
    aerc.enable = config.my.aerc.enable;
  };

  home.packages = with pkgs; [
    claude-code
    fastfetch
    p7zip # 7z
    ripgrep
    tree
    unrar
    unzip
  ];

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    # Match the lowercase directories persisted in modules/nixos/impermanence.nix
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      templates = null;
      publicShare = null;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
