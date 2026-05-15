{ self, ... }:
{
  flake.modules.nixos.swaylock = {
    security.pam.services.swaylock = { };
    home-manager.sharedModules = [
      self.modules.homeManager.swaylock
    ];
  };

  flake.modules.homeManager.swaylock =
    { pkgs, config, ... }:
    let
      clr = config.scheme.withHashtag;
      outside = clr.base00;
      inside = clr.base00;
      ring = clr.base01;
      text = clr.base05;
      positive = clr.base0B;
      negative = clr.base08;

      lockscreen = pkgs.writeShellApplication {
        name = "lockscreen";
        runtimeInputs = with pkgs; [
          grim
          imagemagick
          swaylock
        ];
        text = ''
          IMAGE="/tmp/swaylock-bg.png"
          grim "$IMAGE"
          magick "$IMAGE" -scale 10% -blur 0x2.5 -resize 1000% -level 0%,100%,0.8 "$IMAGE"
          swaylock --daemonize -i "$IMAGE"
        '';
      };
    in
    {
      systemd.user.services.swayidle = {
        Unit = {
          Description = "Idle daemon";
          After = [ "niri.service" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = ''
            ${pkgs.swayidle}/bin/swayidle -w  \
            timeout 290 '${pkgs.libnotify}/bin/notify-send -t 10000 -a lock "Locking in 10 seconds" ' \
            timeout 300 '${lockscreen}/bin/lockscreen' \
            timeout 600 '${pkgs.niri}/bin/niri msg action power-off-monitors' \
            timeout 1200 '${pkgs.systemd}/bin/systemctl suspend' \
            before-sleep '${lockscreen}/bin/lockscreen' \
            after-resume '${pkgs.niri}/bin/niri msg action power-on-monitors'
          '';
          Restart = "on-failure";
        };
      };

      programs.swaylock = {
        enable = true;
        settings = {
          color = outside;
          inside-color = inside;
          inside-clear-color = inside;
          inside-caps-lock-color = inside;
          inside-ver-color = inside;
          inside-wrong-color = inside;
          key-hl-color = positive;
          layout-bg-color = inside;
          layout-border-color = ring;
          layout-text-color = text;
          line-uses-inside = true;
          ring-color = ring;
          ring-clear-color = negative;
          ring-caps-lock-color = ring;
          ring-ver-color = positive;
          ring-wrong-color = negative;
          separator-color = "00000000";
          text-color = text;
          text-clear-color = text;
          text-caps-lock-color = text;
          text-ver-color = text;
          text-wrong-color = text;
        };
      };
    };
}
