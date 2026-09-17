{ self, ... }:
{
  flake.modules.nixos.system-cli = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      system-base
    ];

    environment.systemPackages = with pkgs; [
      file
      tree
    ];
  };

  flake.modules.homeManager.system-cli = {
    imports = with self.modules.homeManager; [
      system-base
    ];
  };
}
