{
  flake.modules.homeManager.swaybg =
    { pkgs, ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/vg/wallhaven-vgyjo3.jpg";
        hash = "sha256-Xc4OeYUZRWGy79sc5yDXJgPhC669zK6iwGKQ395Y+uM=";
      };
    in
    {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Wallpaper service";
          After = [ "niri-service" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '${wallpaper}'";
          Restart = "on-failure";
        };
      };
    };
}
