{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.printing.enable = lib.mkEnableOption "CUPS printing";

  config = lib.mkIf config.my.printing.enable {
    services.printing.enable = true;

    # Driverless IPP Everywhere: the WF-7835 speaks AirPrint/IPP Everywhere
    # natively, so CUPS' built-in "everywhere" driver covers it with no
    # Epson package needed.
    hardware.printers = {
      ensureDefaultPrinter = "epson-wf7835";
      ensurePrinters = [
        {
          name = "epson-wf7835";
          description = "Epson WorkForce WF-7835";
          deviceUri = "ipp://10.0.90.187/ipp/print";
          model = "everywhere";
        }
      ];
    };
  };
}
