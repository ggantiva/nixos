{
  flake.modules.homeManager.kitty =
    { pkgs, config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      programs.kitty = {
        font = {
          name = "Agave Nerd Font Mono";
          package = pkgs.nerd-fonts.agave;
          size = 16;
        };

        settings = {
          disable_ligatures = "always";

          # Tabs
          tab_bar_edge = "top";
          tab_bar_align = "center";
          tab_bar_style = "fade";
          tab_fade = " 1";

          tab_title_template = "{'#' if layout_name == 'stack' else ''}{index}";

          # colors
          background = "${clr.base00}";
          foreground = "${clr.base05}";
          selection_background = "${clr.base05}";
          selection_foreground = "${clr.base00}";
          url_color = "${clr.base04}";
          cursor = "${clr.base05}";
          cursor_text_color = "${clr.base00}";
          active_border_color = "${clr.base03}";
          inactive_border_color = "${clr.base01}";
          active_tab_background = "${clr.base08}";
          active_tab_foreground = "${clr.base01}";
          inactive_tab_background = "${clr.base01}";
          inactive_tab_foreground = "${clr.base04}";
          tab_bar_background = "${clr.base01}";
          wayland_titlebar_color = "${clr.base00}";
          macos_titlebar_color = "${clr.base00}";

          # normal
          color0 = "${clr.base00}";
          color1 = "${clr.base08}";
          color2 = "${clr.base0B}";
          color3 = "${clr.base0A}";
          color4 = "${clr.base0D}";
          color5 = "${clr.base0E}";
          color6 = "${clr.base0C}";
          color7 = "${clr.base05}";

          # bright
          color8 = "${clr.base03}";
          color9 = "${clr.base08}";
          color10 = "${clr.base0B}";
          color11 = "${clr.base0A}";
          color12 = "${clr.base0D}";
          color13 = "${clr.base0E}";
          color14 = "${clr.base0C}";
          color15 = "${clr.base07}";

          # extended
          color16 = "${clr.base09}";
          color17 = "${clr.base0F}";
          color18 = "${clr.base01}";
          color19 = "${clr.base02}";
          color20 = "${clr.base04}";
          color21 = "${clr.base06}";
        };
      };
    };
}
