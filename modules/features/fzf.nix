{ self, inputs, ... }:
{
  flake.modules.nixos.fzf =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [ fzf ];

      programs.bash.interactiveShellInit = /* bash */ ''
        eval "$(fzf --bash)"
      '';
    };

  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      programs.bash.interactiveShellInit = /* bash */ ''
        export FZF_DEFAULT_OPTS='
          --color bg:${clr.base00},bg+:${clr.base01},fg:${clr.base04},fg+:${clr.base06}
          --color header:${clr.base0D},hl:${clr.base0D},hl+:${clr.base0D}
          --color info:${clr.base0A},marker:${clr.base0C},pointer:${clr.base0C}
          --color prompt:${clr.base0A},spinner:${clr.base0C}
        '
      '';
    };
}
