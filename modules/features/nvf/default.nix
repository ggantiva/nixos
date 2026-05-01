{ self, inputs, ... }:
{
  flake.modules.nixos.nvf = {
    imports = [
      inputs.nvf.nixosModules.default
      self.modules.nixos.nvf-languages
    ];

    programs.nvf = {
      enable = true;
      defaultEditor = true;

      settings.vim = {
        viAlias = true;
        vimAlias = true;

        options = {
          tabstop = 2;
          shiftwidth = 2;
          mouse = "a";
          wrap = false;
          foldlevelstart = 99;
        };

        spellcheck = {
          enable = true;
          languages = [
            "es"
            "en"
          ];
        };

        diagnostics = {
          enable = true;
          config = {
            signs = true;
            virtual_text = true;
          };
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "auto";
          };
        };

        telescope = {
          enable = true;
        };

        visuals = {
          nvim-web-devicons.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
        };

        keymaps = [
          {
            key = "<leader>W";
            mode = "n";
            action = ":set wrap!<CR>";
          }
        ];

        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "default";
          };
        };
      };
    };
  };
}
