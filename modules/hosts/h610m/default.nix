{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.h610m = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.h610m
    ];
  };
}
