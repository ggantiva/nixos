{ inputs, ... }:
let
  schemePath = "${inputs.tt-schemes}/base16/vesper.yaml";
in
{
  flake.theme = {
    scheme = schemePath;
    getScheme =
      pkgs:
      (inputs.base16.lib {
        inherit pkgs;
        inherit (pkgs) lib;
      }).mkSchemeAttrs schemePath;
  };

  flake.modules.nixos.base16 = {
    imports = [
      inputs.base16.nixosModule
      { scheme = schemePath; }
    ];
  };

  flake.modules.homeManager.base16 = {
    imports = [
      inputs.base16.homeManagerModule
      { scheme = schemePath; }
    ];
  };
}
