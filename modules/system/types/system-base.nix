{ self, ... }:
{
  flake.modules.nixos.system-base = {
    imports =
      with self.modules.nixos;
      [
        root
        boot
        home-manager
        locale
        impermanence
        sops
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

  flake.modules.homeManager.system-base =
    { config, ... }:
    {
      imports =
        with self.modules.homeManager;
        [
          ssh
          bash
        ]
        ++ (with self.modules.generic; [ constants ]);

      home = {
        homeDirectory = "/home/${config.home.username}";
        stateVersion = "24.11";
      };
    };
}
