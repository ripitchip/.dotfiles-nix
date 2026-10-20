{
  config,
  lib,
  ...
}:
{
  options.my.aerc.enable = lib.mkEnableOption "aerc, a mail client in the terminal";

  config = lib.mkIf config.my.aerc.enable {
    programs.aerc = {
      enable = true;
      # accounts.conf is generated from accounts.email.accounts.*.aerc and lands
      # in the Nix store. Safe: passwords come from passwordCommand, not the file.
      extraConfig.general.unsafe-accounts-conf = true;
      # Show mail bodies inside aerc. Without a filter, aerc asks what to do and
      # `:open` hands the part to xdg-open, which picks VS Code for text/plain.
      # colorize ships with aerc (no extra package).
      extraConfig.filters = {
        "text/plain" = "colorize";
        "message/delivery-status" = "colorize";
      };
    };
  };
}
