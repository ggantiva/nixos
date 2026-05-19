{
  flake.modules.homeManager.kitty = {
    pkgs,
    config,
    ...
  }: let
    clr = config.scheme.withHashtag;
  in {
    home.shellAliases = {
      "icat" = "kitten icat";
    };

    programs.kitty = {
      enable = true;

      font = {
        name = "Agave Nerd Font Mono";
        package = pkgs.nerd-fonts.agave;
        size = 14;
      };

      keybindings = {
        ### Windows ###
        # Movement
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";

        # Zoom in
        "alt+z" = "toggle_layout stack";

        ### Tabs ###
        "alt+y" = "goto_tab 1";
        "alt+u" = "goto_tab 2";
        "alt+i" = "goto_tab 3";
        "alt+o" = "goto_tab 4";
        "alt+p" = "goto_tab 5";
      };

      settings = {
        # Shortcuts
        kitty_mod = "ctrl+shift";

        # Layout
        enabled_layouts = "tall,stack";

        window_resize_step_cells = 5;
        window_resize_step_lines = 5;

        # Tabs
        tab_bar_edge = "top";
        tab_bar_align = "center";
        tab_bar_style = "fade";
        tab_fade = " 1";

        tab_title_template = "{'#' if layout_name == 'stack' else ''}{index}";

        # Pager
        scrollback_pager = "${pkgs.neovim}/bin/nvim --cmd 'set eventignore=FileType' +'hi Normal guibg=NONE ctermbg=NONE' +'nnoremap q ZQ' +'vnoremap y \"+y<cmd>q!<cr>' +'call nvim_open_term(0, {})' +'set nomodified laststatus=0 nolist clipboard+=unnamedplus' +'$' -";

        # blur
        disable_ligatures = "always";

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
