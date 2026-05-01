{ inputs, ... }:
{
  flake.modules.nixos.base16 = {
    imports = [
      inputs.base16.nixosModule
      { scheme = "${inputs.tt-schemes}/base16/atelier-cave.yaml"; }
    ];
  };
}
