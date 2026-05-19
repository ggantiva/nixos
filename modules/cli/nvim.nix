{ inputs, ... }:
{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      ...
    }:
    let
      clr = config.scheme.withHashtag;
      colorScheme = {
        base00 = "${clr.base00}";
        base01 = "${clr.base01}";
        base02 = "${clr.base02}";
        base03 = "${clr.base03}";
        base04 = "${clr.base04}";
        base05 = "${clr.base05}";
        base06 = "${clr.base06}";
        base07 = "${clr.base07}";
        base08 = "${clr.base08}";
        base09 = "${clr.base09}";
        base0A = "${clr.base0A}";
        base0B = "${clr.base0B}";
        base0C = "${clr.base0C}";
        base0D = "${clr.base0D}";
        base0E = "${clr.base0E}";
        base0F = "${clr.base0F}";
      };

      custom-nvim = inputs.nvim-custom.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNvim {
        themeOverride = colorScheme;
      };
    in
    {
      home = {
        sessionVariables = {
          EDITOR = "nvim";
        };

        packages = [ custom-nvim ];
      };
    };
}
