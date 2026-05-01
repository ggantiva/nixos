{ self, inputs, ... }:
{
  flake.modules.nixos.system-base = {
    imports =
      with self.modules.nixos;
      [
        boot
        hjem
        users
        locale
        impermanence
        sops

        nvf
      ]
      ++ (with self.modules.generic; [
        constants
      ]);

    nixpkgs.config.allowUnfree = true;

    # Don't change
    system.stateVersion = "24.11";

    # Enable flakes
    nix = {
      channel.enable = false;

      optimise = {
        automatic = true;
        dates = "20:00";
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        use-xdg-base-directories = true;
      };

      # Disable git warning
      extraOptions = "warn-dirty = false";
    };
  };
}
