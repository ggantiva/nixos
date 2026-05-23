{
  flake.modules.homeManager.wl-clipboard =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ wl-clipboard ];

      systemd.user = {
        timers.clear-clipboard = {
          Unit = {
            Description = "Clears clipboard every 2 minutes";
          };

          Timer = {
            OnBootSec = "2min";
            OnUnitActiveSec = "2min";
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };
        };

        services.clear-clipboard = {
          Unit = {
            Description = "Clears clipboard";
          };

          Service = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-copy --clear";
          };
        };
      };
    };
}
