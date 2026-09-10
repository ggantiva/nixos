{
  flake.modules.homeManager.swaybg =
    {
      pkgs,
      ...
    }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/3l/wallhaven-3l3lzd.png";
        hash = "sha256-2+RbpDG1rPGG2vkKzuVAN7Mhg9uPqS3fTwA97BLvhBg=";
      };
    in
    {
      config = {
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
    };
}
