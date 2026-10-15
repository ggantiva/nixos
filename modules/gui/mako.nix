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
        };
      };
    };
}
