{
  flake.modules.homeManager.foot = {config, ...}: let
    clr = config.scheme;
  in {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "Agave Nerd Font Mono:size=13.5";
          pad = "4x4 center";
          selection-target = "clipboard";
        };

        cursor = {
          beam-thickness = "2px";
          style = "beam";
          unfocused-style = "none";
        };

        colors-dark = {
          alpha = 0.9;
          blur = "yes";
          background = "${clr.base00}";
          foreground = "${clr.base05}";

          regular0 = "${clr.base00}";
          regular1 = "${clr.base08}";
          regular2 = "${clr.base0B}";
          regular3 = "${clr.base0A}";
          regular4 = "${clr.base0D}";
          regular5 = "${clr.base0E}";
          regular6 = "${clr.base0C}";
          regular7 = "${clr.base05}";

          bright0 = "${clr.base03}";
          bright1 = "${clr.base08}";
          bright2 = "${clr.base0B}";
          bright3 = "${clr.base0A}";
          bright4 = "${clr.base0D}";
          bright5 = "${clr.base0E}";
          bright6 = "${clr.base0C}";
          bright7 = "${clr.base07}";

          "16" = "${clr.base09}";
          "17" = "${clr.base0F}";
          "18" = "${clr.base01}";
          "19" = "${clr.base02}";
          "20" = "${clr.base04}";
          "21" = "${clr.base06}";
        };
      };
    };
  };
}
