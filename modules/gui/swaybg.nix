{
  flake.modules.homeManager.swaybg = {
    pkgs,
    config,
    ...
  }: let
    inherit (config.constants) wallpaper;
  in {
    config = {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Wallpaper service";
          After = ["niri-service"];
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };

        Service = {
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '${wallpaper}'";
          Restart = "on-failure";
        };
      };
    };
  };
}
