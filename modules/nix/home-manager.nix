{ self, inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
    };
  };
}
