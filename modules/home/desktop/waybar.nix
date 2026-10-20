{ config, lib, ... }:
{
  config = lib.mkIf config.my.desktop.enable {
    programs.waybar = {
      enable = true;
      # Started with the graphical session instead of niri's spawn-at-startup
      systemd.enable = true;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "wireplumber"
          "network"
          "bluetooth"
          "power-profiles-daemon"
          "battery"
          "tray"
        ];

        "niri/workspaces".format = "{index}";

        "niri/window" = {
          max-length = 60;
          separate-outputs = true;
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            mode-mon-col = 3;
          };
        };

        wireplumber = {
          format = "VOL {volume}%";
          format-muted = "VOL muted";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
          max-volume = 100;
        };

        network = {
          format-wifi = "WIFI {essid} {signalStrength}%";
          format-ethernet = "ETH";
          format-disconnected = "OFFLINE";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        bluetooth = {
          format = "BT";
          format-off = "";
          format-disabled = "";
          format-connected = "BT {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
        };

        power-profiles-daemon = {
          format = "{profile}";
          tooltip-format = "Power profile: {profile}\nClick to cycle";
        };

        battery = {
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
          format-full = "BAT full";
          tooltip-format = "{timeTo}, {power:.1f} W";
          states = {
            warning = 25;
            critical = 10;
          };
        };

        tray.spacing = 8;
      };

      # Colors follow the niri focus ring in niri.kdl (#7fc8ff / #505050)
      style = ''
        * {
          font-family: "Iosevka", monospace;
          font-size: 13px;
          min-height: 0;
          border: none;
          border-radius: 0;
        }

        window#waybar {
          background: rgba(20, 20, 24, 0.92);
          color: #d8d8d8;
        }

        tooltip {
          background: #18181c;
          border: 1px solid #505050;
          border-radius: 6px;
        }

        #workspaces {
          margin-left: 6px;
        }

        #workspaces button {
          padding: 0 8px;
          color: #8a8a8a;
          background: transparent;
          border-bottom: 2px solid transparent;
        }

        #workspaces button.active {
          color: #7fc8ff;
          border-bottom: 2px solid #7fc8ff;
        }

        #workspaces button.urgent {
          color: #ff6b6b;
        }

        #workspaces button:hover {
          background: rgba(255, 255, 255, 0.06);
        }

        #window {
          margin-left: 10px;
          color: #a8a8a8;
        }

        #clock {
          font-weight: bold;
          color: #ffffff;
        }

        #wireplumber,
        #network,
        #bluetooth,
        #power-profiles-daemon,
        #battery,
        #tray {
          padding: 0 10px;
        }

        #tray {
          margin-right: 6px;
        }

        #wireplumber.muted,
        #network.disconnected {
          color: #8a8a8a;
        }

        #power-profiles-daemon.performance {
          color: #ffc87f;
        }

        #power-profiles-daemon.power-saver {
          color: #8fd18f;
        }

        #battery.charging {
          color: #8fd18f;
        }

        #battery.warning:not(.charging) {
          color: #ffc87f;
        }

        #battery.critical:not(.charging) {
          color: #ff6b6b;
        }
      '';
    };
  };
}
