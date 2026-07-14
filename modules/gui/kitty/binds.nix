{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      settings = {
        clear_all_shortcuts = "yes";
        kitty_mod = "ctrl+shift";
      };

      # Vim-kitty-navigator
      extraConfig = ''
        map --when-focus-on var:IS_VIM=true alt+h
        map --when-focus-on var:IS_VIM=true alt+j
        map --when-focus-on var:IS_VIM=true alt+k
        map --when-focus-on var:IS_VIM=true alt+l

        allow_remote_control yes
        listen_on unix:@mykitty
      '';

      keybindings = {
        ### Clipboard ###
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";

        ### Scrolling ###
        # Line
        "ctrl+shift+k" = "scroll_line_up";
        "ctrl+shift+j" = "scroll_line_down";

        # Page
        "ctrl+shift+page_up" = "scroll_page_up";
        "ctrl+shift+page_down" = "scroll_page_down";

        # Top
        "ctrl+shift+home" = "scroll_home";

        # Bottom
        "ctrl+shift+end" = "scroll_end";

        # Pager
        "ctrl+shift+h" = "show_scrollback";

        ### Windows ###
        # Focus
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";

        # Movement
        "ctrl+alt+h" = "move_window left";
        "ctrl+alt+j" = "move_window down";
        "ctrl+alt+k" = "move_window up";
        "ctrl+alt+l" = "move_window right";

        "ctrl+alt+left" = "move_window left";
        "ctrl+alt+down" = "move_window down";
        "ctrl+alt+up" = "move_window up";
        "ctrl+alt+right" = "move_window right";

        # Open
        "ctrl+shift+n" = "new_window_with_cwd";

        # Close
        "ctrl+shift+w" = "close_window";

        # Resize
        "ctrl+shift+r" = "start_resizing_window";

        # Zoom in
        "ctrl+shift+z" = "toggle_layout stack";

        ### Tabs ###
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+q" = "close_tab";

        # Focus
        "alt+y" = "goto_tab 1";
        "alt+u" = "goto_tab 2";
        "alt+i" = "goto_tab 3";
        "alt+o" = "goto_tab 4";
        "alt+p" = "goto_tab 5";

        ### Font size ###
        "ctrl+shift+equal" = "change_font_size all +2.0";
        "ctrl+shift+minus" = "change_font_size all -2.0";
        "ctrl+backspace" = "change_font_size all 0";

        ### Misc ###
        "ctrl+shift+e" = "open_url_with_hints";
        "ctrl+shift+u" = "kitten unicode_input";
      };
    };
  };
}
