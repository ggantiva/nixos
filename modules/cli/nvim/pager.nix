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
        (import ./_theme.nix { inherit pkgs clr; })
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
