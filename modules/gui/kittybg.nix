{
  flake.modules.homeManager.kittybg =
    { pkgs, ... }:
    let
      kittyCommand = "${pkgs.kitty}/bin/kitten panel --override='tab_bar_min_tabs=2' --edge=background --single-instance";
      bgCommand = "${kittyCommand} ${pkgs.terminal-toys}/bin/terminal-toys rings";
    in
    {
      systemd.user.services.kittybg = {
        Unit = {
          Description = "Animated wallpaper using kitty terminal emulator";
          After = [ "graphical-session.target" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = bgCommand;
          Restart = "on-failure";
        };
      };
    };
}
