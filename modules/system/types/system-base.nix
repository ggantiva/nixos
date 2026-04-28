{ self, inputs, ... }:
{
  flake.modules.nixos.system-base = {
    imports =
      with self.modules.nixos;
      [
        boot
        hjem
        users
      ]
      ++ (with self.modules.generic; [
        constants
      ]);

    nixpkgs.config.allowUnfree = true;

    # Don't change
    system.stateVersion = "24.11";

    # Enable flakes
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
