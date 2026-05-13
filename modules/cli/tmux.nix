{
  flake.modules.homeManager.tmux =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      programs.tmux = {
        enable = true;
        extraConfig = /* bash */ ''
          # Enable 256 color support
          set -g default-terminal "tmux-256color"
          set -ga terminal-overrides ",*:RGB"

          # Enable mouse support
          set -g mouse on

          # Enable clipboard
          set -g set-clipboard on

          set -s escape-time 1

          # Set prefix
          unbind C-b
          set -g prefix C-Space
          bind-key C-Space send-prefix

          # Vim-style pane navigation
          bind -n M-h select-pane -L
          bind -n M-j select-pane -D
          bind -n M-k select-pane -U
          bind -n M-l select-pane -R

          # Split windows
          unbind %
          unbind '"'
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"

          # Alt+direction to switch panes
          bind -n S-Left previous-window 
          bind -n S-Right next-window 

          # Alt+number to select window
          bind -n M-1 select-window -t 1
          bind -n M-2 select-window -t 2
          bind -n M-3 select-window -t 3
          bind -n M-4 select-window -t 4
          bind -n M-5 select-window -t 5
          bind -n M-6 select-window -t 6
          bind -n M-7 select-window -t 7
          bind -n M-8 select-window -t 8
          bind -n M-9 select-window -t 9

          # Change index to 1 for comfort
          set -g base-index 1
          set -g pane-base-index 1
          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on

          # Pane Separators
          set -g pane-border-lines simple

          # Vim-style copy/paste
          set-window-option -g mode-keys vi
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          unbind -T copy-mode-vi MouseDragEnd1Pane

          # Open terminal popup
          unbind t
          bind-key t display-popup -d "#{pane_current_path}"

          # Open LazyGit popup
          bind-key g display-popup -d "#{pane_current_path}" -w 80% -h 80% -E lazygit

          # Status bar settings
          set-option -g status-position "top"

          set -g status-left ""
          set -g status-right " [#S] "

          set -g status-style "fg=${clr.base05},bg=${clr.base01}"
          set -g status-right-style "fg=${clr.base0A}"

          set -g pane-border-style "fg=${clr.base01}"
          set -g pane-active-border-style "fg=${clr.base0A}"

          set -g window-status-format " #W "
          set -g window-status-current-format " #W " 
          set -g window-status-current-style "fg=${clr.base01},bg=${clr.base0A}"
        '';
      };
    };

}
