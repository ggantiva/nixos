{ inputs, ... }:
{
  flake.modules.homeManager.nvim = { pkgs, config, ... }:
  let
    clr = config.scheme.withHashtag;

    nvim = inputs.mnw.lib.wrap pkgs {
      appName = "nvim";

      # Autoload files in lazy
      initLua = /* lua */ ''
        require('full') 
        require('lz.n').load('full.plugins')
      '';

      extraBinPath = with pkgs; [
        lua-language-server
        bash-language-server
        nixd

        ripgrep
      ];

      plugins = {
        start = with pkgs.vimPlugins; [
          lz-n
          mini-base16
          vim-kitty-navigator 
          oil-nvim
          mini-statusline
          nvim-treesitter.withAllGrammars
        ];

        # Lazy loaded
        opt = with pkgs.vimPlugins; [
          fzf-lua 
          mini-indentscope
          mini-icons
          mini-cursorword
          highlight-undo-nvim
        ];

        dev.full = {
          pure = ./.;
        };
      };

      # Theme
      luaFiles = [(pkgs.writeText "theme.lua" /*lua*/''
          require('mini.base16').setup({
            use_cterm = true,
            palette = {
              base00 = '${clr.base00}', base01 = '${clr.base01}', base02 = '${clr.base02}', base03 = '${clr.base03}',
              base04 = '${clr.base04}', base05 = '${clr.base05}', base06 = '${clr.base06}', base07 = '${clr.base07}',
              base08 = '${clr.base08}', base09 = '${clr.base09}', base0A = '${clr.base0A}', base0B = '${clr.base0B}',
              base0C = '${clr.base0C}', base0D = '${clr.base0D}', base0E = '${clr.base0E}', base0F = '${clr.base0F}',
            },
          })
      '')];
    };
  in
  {

    home = {
      packages = [ nvim ];

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };
  };
}
