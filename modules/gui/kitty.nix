{
  flake.modules.homeManager.kitty =
    {
      pkgs,
      config,
      ...
    }:
    let
      clr = config.scheme.withHashtag;
    in
    {
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
          ### Tab control ###
          "kitty_mod+t" = "new_tab";
          "kitty_mod+q" = "close_tab";

          # Movement
          "kitty_mod+y" = "goto_tab 1";
          "kitty_mod+u" = "goto_tab 2";
          "kitty_mod+i" = "goto_tab 3";
          "kitty_mod+o" = "goto_tab 4";
          "kitty_mod+p" = "goto_tab 5";

          ### Window control ###
          "kitty_mod+w" = "close_window";
          "kitty_mod+v" = "launch --location=vsplit --cwd=current";
          "kitty_mod+s" = "launch --location=hsplit --cwd=current";

          # Movement
          "kitty_mod+ctrl+h" = "move_window left";
          "kitty_mod+ctrl+j" = "move_window down";
          "kitty_mod+ctrl+k" = "move_window up ";
          "kitty_mod+ctrl+l" = "move_window right";

          "kitty_mod+h" = "neighboring_window left";
          "kitty_mod+j" = "neighboring_window down";
          "kitty_mod+k" = "neighboring_window up";
          "kitty_mod+l" = "neighboring_window right";

          # Zoom in
          "kitty_mod+z" = "toggle_layout stack";

          # Resize
          "kitty_mod+r" = "start_resizing_window";

          ### Clipboard ###
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";
        };

        settings = {
          # Shortcuts
          clear_all_shortcuts = "yes";
          kitty_mod = "alt";

          # Layouts
          enabled_layouts = "splits,stack";

          # Tabs
          tab_title_template = "{' #' if layout_name == 'stack' else '  '}{fmt.fg.red}{bell_symbol}{fmt.fg.tab}{title}  ";

          scrollback_pager = "nvim --noplugin --cmd 'set eventignore=FileType' +'nnoremap q ZQ' +'vnoremap y \"+y<cmd>q!<cr>' +'call nvim_open_term(0, {})' +'set nomodified nolist clipboard+=unnamedplus' +'$' -";

          ### Theme ###
          disable_ligatures = "always";
          # blur
          background_opacity = 0.9;
          background_blur = 1;

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
          active_tab_background = "${clr.base00}";
          active_tab_foreground = "${clr.base05}";
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
