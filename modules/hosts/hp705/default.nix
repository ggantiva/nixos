{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.hp705 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.hp705
    ];
  };
}
