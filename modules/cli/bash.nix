{ self, inputs, ... }:
{
  flake.modules.nixos.bash = {
    programs.git.prompt.enable = true;
    nix.settings.bash-prompt-prefix = ''\[\e[91m\]nix: \[\e[0m\]'';

    programs.bash = {
      promptInit = /* bash */ ''
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
      '';
      interactiveShellInit = /* bash */ ''
        set -o "vi"

        shopt -s cdspell
        shopt -s autocd

        export HISTSIZE=5000
        export HISTFILESIZE=20000
        export HISTCONTROL=ignoredups:eradeups:ignorespace

        export LESS_TERMCAP_mb=$'\e[1;31m'
        export LESS_TERMCAP_md=$'\e[1;31m'
        export LESS_TERMCAP_me=$'\e[0m'
        export LESS_TERMCAP_se=$'\e[0m'
        export LESS_TERMCAP_so=$'\e[1;33;44m'
        export LESS_TERMCAP_ue=$'\e[0m'
        export LESS_TERMCAP_us=$'\e[4;1;32m'
        export LESS_TERMCAP_mr=$'\e[7m'
        export LESS_TERMCAP_mh=$'\e[2m'
        export LESS_TERMCAP_ZN=$'\e[74m'
        export LESS_TERMCAP_ZV=$'\e[75m'
        export LESS_TERMCAP_ZO=$'\e[73m'
        export LESS_TERMCAP_ZW=$'\e[75m'
        export MANPAGER='less'
      '';
      shellAliases = {
        c = "clear";
        nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos-config";
      };
    };
    environment.etc.inputrc.text = /* bash */ ''
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
}
