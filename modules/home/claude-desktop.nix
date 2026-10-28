{
  config,
  lib,
  inputs,
  osConfig,
  pkgs,
  ...
}:
let
  # Anthropic's official .deb, repackaged by the claude-desktop-debian flake
  # (`nix flake update claude-desktop` to bump). Built against our nixpkgs.
  package = pkgs.callPackage "${inputs.claude-desktop}/nix/claude-desktop.nix" { };

  # Same as Signal (see signal.nix): Electron doesn't know niri and would keep
  # its encryption key in plain text; use the Secret Service (oo7) instead.
  #
  # --disable-gpu-sandbox: on this NVIDIA system the GPU process fails to
  # even launch under its sandbox (~/.config/Claude/logs/main.log: "GPU
  # process gone, reason: launch-failed, exitCode: 1002", crash-looping).
  # The sidebar (plain DOM/CSS) still renders, but the chat pane needs
  # GPU compositing and stays solid black. Not a packaging/runpath issue
  # (libglvnd + /run/opengl-driver are correctly wired); lifting just the
  # GPU process's sandbox lets it start while keeping hardware acceleration.
  claude-desktop = pkgs.symlinkJoin {
    name = "claude-desktop";
    paths = [ package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude-desktop --add-flags "--password-store=gnome-libsecret --disable-gpu-sandbox"
    '';
  };
in
{
  options.my.claude-desktop.enable = lib.mkEnableOption "the Claude Desktop app";

  config = lib.mkIf config.my.claude-desktop.enable {
    home.packages = [ claude-desktop ];

    home.persistence.${osConfig.my.impermanence.persistPath}.directories = [
      ".config/Claude" # login, settings, MCP servers (claude_desktop_config.json)
    ];
  };
}
