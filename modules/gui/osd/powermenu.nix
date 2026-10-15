{ withSystem, ... }:
{
  flake.modules.homeManager.osd =
    { pkgs, ... }:
    let
      lockscreen = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }: config.packages.lockscreen
      );
    in
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "powermenu";
          text = ''
            options=$(printf "   Lock\n󰤄   Suspend\n󰜉   Reboot\n   Shutdown" | fuzzel -d)

            case "$options" in
            "   Lock")
              ${lockscreen}/bin/lockscreen
              ;;
            "󰤄   Suspend")
              ${lockscreen}/bin/lockscreen
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
      ];
    };
}
