{
  flake.modules.homeManager.osd =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "wp-vol";
          runtimeInputs = with pkgs; [
            bc
            wireplumber
            libnotify
          ];

          text = ''
            volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
            volume=$(echo "$volume" | awk '{print $2}')
            volume=$(echo "( $volume * 100 ) / 1" | bc)

            notify-send -t 1000 -a 'wp-vol' -h int:value:"$volume" " "
          '';
        })
      ];
    };

  flake.modules.homeManager.mako =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      services.mako.settings = {
        "app-name=wp-vol" = {
          text-color = "${clr.base01}";
          layer = "overlay";
          history = 0;
          anchor = "bottom-center";
          group-by = "app-name";
          format = "<b>%s</b>\\n%b";
          outer-margin = 30;
          width = 250;
        };

        "app-name=volume group-index=0" = {
          invisible = 0;
        };
      };
    };
}
