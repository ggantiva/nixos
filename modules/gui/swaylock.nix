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

      inherit (config.constants) wallpaper;
      background = pkgs.runCommand "background.png" {
        buildInputs = [ pkgs.imagemagick ];
        # Blur the image and darken it
      } ''magick "${wallpaper}" -scale 10% -blur 0x2.5 -resize 1000% -level 0%,100%,0.8 $out'';
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
            timeout 290 '${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds" -t 10000' \
            timeout 300 '${pkgs.swaylock}/bin/swaylock --daemonize' \
            timeout 600 '${pkgs.niri}/bin/niri msg action power-off-monitors' \
            timeout 1200 '${pkgs.systemd}/bin/systemctl suspend' \
            before-sleep '${pkgs.swaylock}/bin/swaylock --daemonize' \
            after-resume '${pkgs.niri}/bin/niri msg action power-on-monitors'
          '';
          Restart = "on-failure";
        };
      };

      programs.swaylock = {
        enable = true;
        settings = {
          image = "${background}";
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
