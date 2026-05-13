{ inputs, ... }:
{
  flake.modules.homeManager.base16 = {
    imports = [
      inputs.base16.homeManagerModule
      { scheme = "${inputs.tt-schemes}/base16/vesper.yaml"; }
    ];
  };

  flake.modules.nixos.base16 = {
    imports = [
      inputs.base16.nixosModule
      { scheme = "${inputs.tt-schemes}/base16/vesper.yaml"; }
    ];
  };
}
