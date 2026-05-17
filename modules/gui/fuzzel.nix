{
  flake.modules.homeManager.fuzzel = {config, ...}: let
    clr = config.scheme;
  in {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          use-bold = "yes";
          placeholder = "Search...";
          icons-enabled = "false";
          minimal-lines = "true";
          horizontal-pad = "20";
          vertical-pad = "20";
          inner-pad = "10";
          lines = "10";
          width = "25";
          font = "Noto Sans:size=12";
          terminal = "foot -a '{cmd}' -T '{cmd}' {cmd}";
        };

        border = {
          width = "3";
          radius = "0";
        };

        colors = {
          background = "${clr.base00}e6";
          text = "${clr.base05}ff";
          placeholder = "${clr.base03}ff";
          prompt = "${clr.base05}ff";
          input = "${clr.base05}ff";
          match = "${clr.base0A}ff";
          selection = "${clr.base03}ff";
          selection-text = "${clr.base05}ff";
          selection-match = "${clr.base0A}ff";
          counter = "${clr.base06}ff";
          border = "${clr.base08}ff";
        };
      };
    };
  };
}
