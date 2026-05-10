{
  flake.modules.homeManager.zathura =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      programs.zathura = {
        enable = true;
        options = {
          recolor = true;
          recolor-reverse-video = true;
          recolor-keephue = true;

          default-bg = "${clr.base00}";
          default-fg = "${clr.base01}";

          statusbar-fg = "${clr.base04}";
          statusbar-bg = "${clr.base02}";

          inputbar-bg = "${clr.base00}";
          inputbar-fg = "${clr.base07}";

          notification-bg = "${clr.base00}";
          notification-fg = "${clr.base07}";
          notification-error-bg = "${clr.base00}";
          notification-error-fg = "${clr.base08}";
          notification-warning-bg = "${clr.base00}";
          notification-warning-fg = "${clr.base08}";

          highlight-color = "${clr.base0A}";
          highlight-active-color = "${clr.base0D}";

          completion-bg = "${clr.base01}";
          completion-fg = "${clr.base0D}";
          completion-highlight-fg = "${clr.base07}";
          completion-highlight-bg = "${clr.base0D}";

          recolor-lightcolor = "${clr.base00}";
          recolor-darkcolor = "${clr.base06}";
        };
      };
    };
}
