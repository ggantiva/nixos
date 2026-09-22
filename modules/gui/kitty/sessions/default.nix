{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
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
              findutils
              coreutils
              gnused
            ];
            text = ''
              SESSION_DIR="$HOME/.config/kitty/sessions"
              DEV_DIR="$HOME/Development"

              mkdir -p "$SESSION_DIR"

              # Collect static session names
              sessions=""
              if [ -d "$SESSION_DIR" ]; then
                sessions=$(find "$SESSION_DIR" -maxdepth 1 -name "*.kitty-session" -exec basename {} .kitty-session \;)
              fi

              # Collect project directories from ~/Development
              projects=""
              if [ -d "$DEV_DIR" ]; then
                projects=$(find "$DEV_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
              fi

              # Combine unique session and project names
              all_targets=$(printf '%s\n%s\n' "$sessions" "$projects" | sed '/^$/d' | sort -u)

              if [ -z "$all_targets" ]; then
                echo "No sessions or projects found"
                exit 1
              fi

              SELECTED=$(echo "$all_targets" | fzf --style full --reverse --prompt="Select Session: ")

              if [ -z "$SELECTED" ]; then
                exit 0
              fi

              TARGET_SESSION_FILE="$SESSION_DIR/$SELECTED.kitty-session"

              # If session file does not exist, generate it for ~/Development project
              if [ ! -f "$TARGET_SESSION_FILE" ] && [ -d "$DEV_DIR/$SELECTED" ]; then
                cat <<EOF > "$TARGET_SESSION_FILE"
              layout tall
              cd $DEV_DIR/$SELECTED

              launch --var window=first --title "$SELECTED" nvim
              launch --bias=20

              focus_matching_window var:window=first
              EOF
              fi

              # Jump to session
              if [ -f "$TARGET_SESSION_FILE" ]; then
                kitty @ action goto_session "$TARGET_SESSION_FILE"
              fi
            '';
          })
        ];
      };
    };
}
