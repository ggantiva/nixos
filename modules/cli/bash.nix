{
  # programs.git.prompt.enable = true;
  flake.modules.homeManager.bash =
    { pkgs, ... }:
    {
      programs.bash = {
        enable = true;
        shellAliases = {
          c = "clear";
          nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos-config";
        };
        initExtra = /* bash */ ''
          # Prompt
          source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
          GIT_PS1_SHOWDIRTYSTATE=1
          GIT_PS1_SHOWSTASHSTATE=1
          GIT_PS1_SHOWUNTRACKEDFILES=1
          GIT_PS1_SHOWUPSTREAM="auto"
          GIT_PS1_HIDE_IF_PWD_IGNORED=1
          GIT_PS1_SHOWCOLORHINTS=true
          PROMPT_DIRTRIM=2

          if [ -n "$SSH_CLIENT" ]; then
            PS1='\[\e[91m\][\u@\h] \[\e[0m\]\[\e[95m\]\w\[\e[0m\] \[\e[96m\]$(__git_ps1 "(%s) ")\[\e[0m\]\n '
          elif [ "$EUID" -eq 0 ]; then
            PS1='\[\e[91m\]\u: \[\e[0m\]\[\e[95m\]\w\[\e[0m\] \[\e[96m\]$(__git_ps1 "(%s) ")\[\e[0m\]\n '
          else
            PS1='\[\e[95m\]\w\[\e[0m\] \[\e[96m\]$(__git_ps1 "(%s) ")\[\e[0m\]\n '
          fi

          # Add colors to man pages
          export MANPAGER="less -M -R -i --use-color -Dd+R -Du+B -DHkC -j5"
          export MANROFFOPT="-c"  

          set -o "vi"

          shopt -s cdspell
          shopt -s autocd

          export HISTSIZE=5000
          export HISTFILESIZE=20000
          export HISTCONTROL=ignoredups:eradeups:ignorespace
        '';
      };

      # Prompt
      programs.readline = {
        enable = true;
        extraConfig = ''
          set bell-style none

          set meta-flag on
          set input-meta on
          set convert-meta off
          set output-meta on
          set colored-stats on

          set show-mode-in-prompt on
          set vi-cmd-mode-string "\1\e[33m\2v\1\e[0m\2"
          set vi-ins-mode-string "\1\e[32m\2>\1\e[0m\2"

          set show-all-if-unmodified on
        '';
      };
    };
}
