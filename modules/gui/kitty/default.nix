{
  flake.modules.homeManager.kitty =
    {
      pkgs,
      ...
    }:
    {
      home.shellAliases = {
        "icat" = "kitten icat";
      };

      programs.kitty = {
        enable = true;
        settings = {
          # Layout
          enabled_layouts = "splits,stack";

          window_resize_step_cells = 5;
          window_resize_step_lines = 5;

          # Pager
          scrollback_pager = "${pkgs.neovim}/bin/nvim --cmd 'set eventignore=FileType' +'hi Normal guibg=NONE ctermbg=NONE' +'nnoremap q ZQ' +'vnoremap y \"+y<cmd>q!<cr>' +'call nvim_open_term(0, {})' +'set nomodified laststatus=0 nolist clipboard+=unnamedplus' +'$' -";
        };
      };
    };
}
