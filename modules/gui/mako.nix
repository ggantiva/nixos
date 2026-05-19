{
  flake.modules.homeManager.mako =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      services.mako = {
        enable = true;
        settings = {
          default-timeout = 8000;
          font = "Noto Sans 12";
          border-size = 3;
          text-color = "${clr.base05}";
          background-color = "${clr.base01}";
          border-color = "${clr.base08}";
          progress-color = "over ${clr.base08}e6";

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

          "app-name=togglemicrophone" = {
            layer = "overlay";
            history = 0;
            anchor = "bottom-center";
            group-by = "app-name";
            format = "<b>%s</b>\\n%b";
            width = 50;
            text-alignment = "center";
          };

          "app-name=clock" = {
            layer = "overlay";
            history = 0;
            anchor = "top-center";
            group-by = "app-name";
            format = "<b>%s</b>\\n%b";
            width = 125;
            text-alignment = "center";
          };

          "app-name=yubikey-touch-detector" = {
            layer = "overlay";
            anchor = "center";
            text-alignment = "center";
            ignore-timeout = 1;
            default-timeout = 4000;
            history = 0;
          };

          "app-name=lock" = {
            layer = "overlay";
            anchor = "center";
            text-alignment = "center";
            history = 0;
            width = 200;
          };

          "app-name=volume group-index=0" = {
            invisible = 0;
          };
        };
      };
    };
}
