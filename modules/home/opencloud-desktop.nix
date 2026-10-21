{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Upstream ships two near-identical launcher entries (opencloud.desktop and
  # opencloudcmd.desktop, the latter meant for the CLI sync tool only), so
  # app launchers show "OpenCloud Desktop" twice. Hide the CLI one.
  opencloud-desktop = pkgs.opencloud-desktop.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # NoDisplay only takes effect in [Desktop Entry]; appending it at EOF
      # would land inside the trailing [Desktop Action Quit] group instead.
      sed -i '/^\[Desktop Entry\]/a NoDisplay=true' $out/share/applications/opencloudcmd.desktop
    '';
  });
in
{
  options.my.opencloud-desktop.enable = lib.mkEnableOption "OpenCloud Desktop, a sync client for OpenCloud/ownCloud servers";

  config = lib.mkIf config.my.opencloud-desktop.enable {
    home.packages = [ opencloud-desktop ];

    # Qt/qtkeychain talks to the Secret Service (oo7, see modules/nixos/desktop.nix)
    # directly, no password-store flag needed like the Electron apps.
    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/OpenCloud" # account, sync folder pairs, settings
      "OpenCloud" # the synced files themselves
    ];
  };
}
