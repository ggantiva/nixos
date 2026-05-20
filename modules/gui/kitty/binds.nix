{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      settings = {
        clear_all_shortcuts = "yes";
        kitty_mod = "ctrl+shift";
      };
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
        "ctrl+shift+[" = "show_scrollback";

        ### Windows ###
        # Focus
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";

        # Movement
        "alt+ctrl+h" = "move_window left";
        "alt+ctrl+j" = "move_window down";
        "alt+ctrl+k" = "move_window up";
        "alt+ctrl+l" = "move_window right";

        # Split/Open
        "alt+v" = "launch --location=vsplit --cwd=current";
        "alt+s" = "launch --location=hsplit --cwd=current";

        # Close
        "alt+w" = "close_window";

        # Resize
        "alt+r" = "start_resizing_window";

        # Zoom in
        "alt+z" = "toggle_layout stack";

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
