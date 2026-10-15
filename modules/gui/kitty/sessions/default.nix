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
          "ctrl+shift+s" = "launch --allow-remote-control --type tab --title 'misc-tab' kitty-session-fzf";
        };
      };

      home = {
        packages = [
          (pkgs.writeShellApplication {
            name = "kitty-session-fzf";
            runtimeInputs = with pkgs; [
              fzf
              kitty
              coreutils
            ];
            text = ''
              SESSION_DIR="$HOME/.config/kitty/sessions"
              DEV_DIR="$HOME/Development"

              # Sessions exempt from removal even if they don't have a directory in ~/Development
              EXEMPT_SESSIONS=("home" "notes")

              is_exempt() {
                local session="$1"
                for exempt in "''${EXEMPT_SESSIONS[@]}"; do
                  if [ "''${session,,}" = "''${exempt,,}" ]; then
                    return 0
                  fi
                done
                return 1
              }

              mkdir -p "$SESSION_DIR"

              targets=()

              # Clean up stale sessions and collect valid session names in a single pass
              if [ -d "$SESSION_DIR" ]; then
                for session_file in "$SESSION_DIR"/*.kitty-session; do
                  [ -e "$session_file" ] || [ -L "$session_file" ] || continue
                  filename="''${session_file##*/}"
                  session_name="''${filename%.kitty-session}"

                  # Only remove if DEV_DIR is valid, session is not a symlink (e.g. Home Manager) and not exempt
                  if [ -d "$DEV_DIR" ] && [ ! -L "$session_file" ] && ! is_exempt "$session_name" && [ ! -d "$DEV_DIR/$session_name" ]; then
                    rm -f "$session_file"
                    continue
                  fi

                  targets+=("$session_name")
                done
              fi

              # Collect project directories from ~/Development
              if [ -d "$DEV_DIR" ]; then
                for project_path in "$DEV_DIR"/*/; do
                  [ -d "$project_path" ] || continue
                  project_dir="''${project_path%/}"
                  project_name="''${project_dir##*/}"
                  targets+=("$project_name")
                done
              fi

              if [ "''${#targets[@]}" -eq 0 ]; then
                echo "No sessions or projects found"
                exit 1
              fi

              all_targets=$(printf '%s\n' "''${targets[@]}" | sort -u)

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
