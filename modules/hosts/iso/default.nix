{ self, inputs, ... }:
{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      self.modules.nixos.iso
    ];
  };
}
