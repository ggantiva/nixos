{ self, inputs, ... }:
let
  mkNvimPager =
    {
      pkgs,
      clr ? (self.theme.getScheme pkgs).withHashtag,
    }:
    inputs.mnw.lib.wrap pkgs {
      appName = "nvim-pager";
      desktopEntry = false;
      aliases = [ "nvim-pager" ];

      initLua = /* lua */ ''
        require('pager')
      '';

      plugins = {
        start = with pkgs.vimPlugins; [
          mini-base16
        ];

        dev.pager = {
          pure = ./.;
        };
      };

      luaFiles = [
        (pkgs.writeText "theme.lua" /* lua */ ''
          require('mini.base16').setup({
            use_cterm = true,
            palette = {
              base00 = '${clr.base00}',
              base01 = '${clr.base01}',
              base02 = '${clr.base02}',
              base03 = '${clr.base03}',
              base04 = '${clr.base04}',
              base05 = '${clr.base05}',
              base06 = '${clr.base06}',
              base07 = '${clr.base07}',
              base08 = '${clr.base08}',
              base09 = '${clr.base09}',
              base0A = '${clr.base0A}',
              base0B = '${clr.base0B}',
              base0C = '${clr.base0C}',
              base0D = '${clr.base0D}',
              base0E = '${clr.base0E}',
              base0F = '${clr.base0F}',
            },
          })
        '')
      ];
    };
in
{
  flake.modules.homeManager.nvim-pager =
    { pkgs, config, ... }:
    let
      clr = config.scheme.withHashtag;
      nvim-pager = mkNvimPager { inherit pkgs clr; };
    in
    {
      home.packages = [ nvim-pager ];
    };

  perSystem =
    { pkgs, ... }:
    let
      nvim-pager = mkNvimPager { inherit pkgs; };
    in
    {
      packages = {
        inherit nvim-pager;
        pager = nvim-pager;
      };
    };
}
