{ self, inputs, ... }:
{
  flake.modules.nixos.swayidle =
    { pkgs, ... }:
    {
      systemd.user.services.swayidle = {
        description = "Swayidle daemon";
        after = [ "niri.service" ];
        wantedBy = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = ''
            ${pkgs.swayidle}/bin/swayidle -w  \
            timeout 290 '${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds" -t 10000' \
            timeout 300 '${pkgs.swaylock}/bin/swaylock --daemonize' \
            timeout 600 '${pkgs.niri}/bin/niri msg action power-off-monitors' \
            timeout 1200 'systemctl suspend' \
            before-sleep '${pkgs.swaylock}/bin/swaylock --daemonize' \
            after-resume '${pkgs.niri}/bin/niri msg action power-on-monitors'
          '';
          Restart = "on-failure";
        };
      };
    };
}
