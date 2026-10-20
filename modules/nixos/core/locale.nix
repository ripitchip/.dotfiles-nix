{
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  # niri reads this through org.freedesktop.locale1 (its xkb block is empty)
  services.xserver.xkb = {
    layout = "us";
    # US International with AltGr dead keys: AltGr+e → é, AltGr+, → ç, ...
    variant = "altgr-intl";
    options = "caps:swapescape";
  };
  # Same layout and Caps/Escape swap on the TTY and in ly
  console.useXkbConfig = true;
}
