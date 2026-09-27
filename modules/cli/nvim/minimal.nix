{ self, inputs, ... }:
let
  mkNvimMinimal =
    {
      pkgs,
      clr ? (self.theme.getScheme pkgs).withHashtag,
    }:
    inputs.mnw.lib.wrap pkgs {
      appName = "nvim-minimal";
      desktopEntry = false;
      aliases = [ "nvim-minimal" ];

      initLua = /* lua */ ''
        require('minimal')
      '';

      plugins = {
        start = with pkgs.vimPlugins; [
          mini-base16
        ];

        dev.minimal = {
          pure = ./.;
        };
      };

      luaFiles = [
        (import ./_theme.nix { inherit pkgs clr; })
      ];
    };
in
{
  flake.modules.homeManager.nvim-minimal =
    { pkgs, config, ... }:
    let
      clr = config.scheme.withHashtag;
      nvim-minimal = mkNvimMinimal { inherit pkgs clr; };
    in
    {
      home = {
        packages = [ nvim-minimal ];

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
      nvim-minimal = mkNvimMinimal { inherit pkgs; };
    in
    {
      packages = {
        inherit nvim-minimal;
        minimal = nvim-minimal;
      };
    };
}
