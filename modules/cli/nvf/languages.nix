{ self, inputs, ... }:
{
  flake.modules.nixos.nvf-languages = {
    programs.nvf.settings.vim = {
      lsp = {
        enable = true;
        formatOnSave = true;
        otter-nvim.enable = true;
      };

      treesitter = {
        enable = true;
        fold = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        html = {
          enable = true;
          lsp.servers = [
            "emmet-ls"
            "superhtml"
          ];
        };

        css.enable = true;

        bash.enable = true;

        yaml.enable = true;

        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
        };

        typescript.enable = true;

        nix = {
          enable = true;
          extraDiagnostics = {
            types = [
              "deadnix"
              "statix"
            ];
          };

          format = {
            type = [ "nixfmt" ];
          };

          lsp.servers = [
            "nixd"
            "nil"
          ];
        };

        typst = {
          enable = true;
        };
      };
    };
  };
}
