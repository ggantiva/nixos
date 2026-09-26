{ self, ... }:
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
          enabled_layouts = "tall,fat,stack";

          window_resize_step_cells = 5;
          window_resize_step_lines = 5;
          startup_session = "~/.config/kitty/sessions/home.kitty-session";

          # Pager
          scrollback_pager = "${self.packages.${pkgs.stdenv.hostPlatform.system}.nvim-pager}/bin/nvim-pager -";
        };
      };
    };
}
