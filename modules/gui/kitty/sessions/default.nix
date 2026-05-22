{
  flake.modules.homeManager.kitty =
    { lib, pkgs, ... }:
    let
      projects = {
        "nixos" = "~/.config/nixos";
        "nvim" = "~/.config/nvim";
      };
    in
    {
      programs.kitty = {
        settings = {
          # Only show tabs belonging to the same session
          tab_bar_filter = "session:~ or session:^$";
        };

        keybindings = {
          "ctrl+shift+s" =
            "launch --allow-remote-control --title session-select --type tab kitty-session-fzf";
        };
      };

      home = {
        packages = [
          (pkgs.writeShellApplication {
            name = "kitty-session-fzf";
            runtimeInputs = with pkgs; [
              fzf
              kitty
            ];
            text = ''
              SESSION_DIR="$HOME/.config/kitty/sessions"
               if [ ! -d "$SESSION_DIR" ] || [ -z "$(ls -A "$SESSION_DIR")" ]; then
                 echo "No Sessions found in $SESSION_DIR"
                 exit 1
               fi

               SELECTED=$(find "$SESSION_DIR" -name "*.kitty-session" -exec basename {} .kitty-session \; | \
                          fzf --style full --reverse --prompt="Select Session: ")

               if [ -z "$SELECTED" ]; then
                 exit 0
               fi

               kitty @ action goto_session "$SESSION_DIR/$SELECTED.kitty-session"
            '';
          })
        ];

        file = lib.attrsets.mapAttrs' (name: path: {
          name = ".config/kitty/sessions/${name}.kitty-session";
          value = {
            text = ''
              layout splits
              cd ${path}

              launch --var window=first --title "${name}" vi
              launch --location=vsplit --bias=20

              focus_matching_window var:window=first
            '';
          };
        }) projects;
      };
    };
}
