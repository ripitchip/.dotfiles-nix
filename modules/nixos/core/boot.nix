{
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Keep /boot from filling up with old generations
      configurationLimit = 10;
      # Disallow editing the kernel command line at boot (would allow init=/bin/sh)
      editor = false;
    };
    efi.canTouchEfiVariables = true;
  };
}
