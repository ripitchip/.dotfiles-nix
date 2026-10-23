# Sable isn't in nixpkgs, and its own flake only builds the static web
# frontend, not the desktop app (see git.sable.moe/SableClient/sable-next).
# Flathub's build (moe.sable.client) just repackages the same upstream
# release binary, but tracks new releases on its own, so install through
# that instead of hand-rolling and re-pinning a derivation here.
{
  config,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  options.my.sable.enable = lib.mkEnableOption "Sable, a Matrix client (installed from Flathub)";

  config = lib.mkIf config.my.sable.enable {
    services.flatpak.packages = [ "moe.sable.client" ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".var/app/moe.sable.client" # profile: session, settings, E2E crypto keys
    ];
  };
}
