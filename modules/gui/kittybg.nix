{
  flake.modules.homeManager.kittybg =
    {
      pkgs,
      config,
      ...
    }:
    let
      clr = config.scheme;
    in
    {
      systemd.user.services.kittybg = {
        Unit = {
          Description = "Wallpaper service";
          Requisite = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.kitty}/bin/kitten panel --edge=background --single-instance ${pkgs.lavat}/bin/lavat -g -s 2 -b 8 -r 3 -c ${clr.base08} -k ${clr.base09}";
          Restart = "on-failure";
        };
      };
    };
}
