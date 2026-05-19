{
  flake.modules.homeManager.osd =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "clock";
          runtimeInputs = with pkgs; [ libnotify ];
          text = ''notify-send -t 1000 -a clock "$(date '+   %I:%M %p')"'';
        })

        (pkgs.writeShellApplication {
          name = "powermenu";
          text = ''
            options=$(printf "   Lock\n󰤄   Suspend\n󰜉   Reboot\n   Shutdown" | fuzzel -d)

            case "$options" in
            "   Lock")
              ${pkgs.swaylock}/bin/swaylock --daemonize
              ;;
            "󰤄   Suspend")
              ${pkgs.swaylock}/bin/swaylock --daemonize
              systemctl suspend
              ;;
            "󰜉   Reboot")
              systemctl reboot
              ;;
            "   Shutdown")
              systemctl poweroff
              ;;
            esac
          '';
        })

        (pkgs.writeShellApplication {
          name = "togglemicrophone";
          runtimeInputs = with pkgs; [
            wireplumber
            libnotify
          ];
          text = ''
            state=$(wpctl get-volume @DEFAULT_SOURCE@)
            if [[ "$state" == *"[MUTED]"* ]]; then
              state="󰍱"
            else
              state="󰍰"
            fi

            notify-send -t 1000 -a 'togglemicrophone' "$state"
          '';
        })
        (pkgs.writeShellApplication {
          name = "wp-vol";
          runtimeInputs = with pkgs; [
            bc
            wireplumber
            libnotify
          ];

          text = ''
            volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
            volume=$(echo "$volume" | awk '{print $2}')
            volume=$(echo "( $volume * 100 ) / 1" | bc)

            notify-send -t 1000 -a 'wp-vol' -h int:value:"$volume" " "
          '';
        })
      ];
    };
}
