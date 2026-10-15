{
  flake.modules.homeManager.osd =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "togglemicrophone";
          runtimeInputs = with pkgs; [
            wireplumber
            libnotify
          ];
          text = ''
            state=$(wpctl get-volume @DEFAULT_SOURCE@)
            if [[ "$state" == *"[MUTED]"* ]]; then
              state="󰍱"
            else
              state="󰍰"
            fi

            notify-send -t 1000 -a 'togglemicrophone' "$state"
          '';
        })
      ];
    };

  flake.modules.homeManager.mako = {
    services.mako.settings = {
      "app-name=togglemicrophone" = {
        layer = "overlay";
        history = 0;
        anchor = "bottom-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 50;
        text-alignment = "center";
      };
    };
  };
}
