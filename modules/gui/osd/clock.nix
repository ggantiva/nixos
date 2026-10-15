{
  flake.modules.homeManager.osd =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "clock";
          runtimeInputs = with pkgs; [ libnotify ];
          text = ''notify-send -t 1000 -a clock "$(date '+   %I:%M %p')"'';
        })
      ];
    };

  flake.modules.homeManager.mako = {
    services.mako.settings = {
      "app-name=clock" = {
        layer = "overlay";
        history = 0;
        anchor = "top-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 125;
        text-alignment = "center";
      };
    };
  };
}
