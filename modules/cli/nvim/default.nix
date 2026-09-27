{ self, inputs, ... }:
let
  mkNvim =
    {
      pkgs,
      clr ? (self.theme.getScheme pkgs).withHashtag,
    }:
    inputs.mnw.lib.wrap pkgs {
      appName = "nvim";

      # Autoload files in lazy
      initLua = /* lua */ ''
        require('default')
        require('lz.n').load('default.plugins')
      '';

      extraBinPath = with pkgs; [
        # Tools
        ripgrep

        # LSP
        lua-language-server
        bash-language-server
        vscode-langservers-extracted
        typescript-language-server
        basedpyright
        nixd

        # Formatters
        prettierd
        nixfmt
        stylua
        shfmt

        # Linters
        ruff
        eslint_d
        shellcheck
        markdownlint-cli2
      ];

      plugins = {
        start = with pkgs.vimPlugins; [
          lz-n
          mini-base16
          vim-kitty-navigator
          oil-nvim
          mini-statusline
          nvim-treesitter.withAllGrammars
          otter-nvim
          nvim-lint
          conform-nvim
          friendly-snippets
        ];

        # Lazy loaded
        opt = with pkgs.vimPlugins; [
          fzf-lua
          mini-indentscope
          mini-icons
          mini-cursorword
          highlight-undo-nvim
          render-markdown-nvim
          gitsigns-nvim
          blink-cmp
        ];

        dev.default = {
          pure = ./.;
        };
      };

      # Theme
      luaFiles = [
        (import ./_theme.nix { inherit pkgs clr; })
      ];
    };
in
{
  flake.modules.homeManager.nvim =
    { pkgs, config, ... }:
    let
      clr = config.scheme.withHashtag;
      nvim = mkNvim { inherit pkgs clr; };
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

  perSystem =
    { pkgs, ... }:
    let
      nvim = mkNvim { inherit pkgs; };
    in
    {
      packages = {
        inherit nvim;
        default = nvim;
      };
    };
}
