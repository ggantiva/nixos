{ self, inputs, ... }:
{
  flake.modules.nixos.system-base = {
    imports =
      with self.modules.nixos;
      [
        boot
        home-manager
        hjem
        users
        locale
        impermanence
        sops

        tmux
        bash
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
    let
      inherit (config.constants) user;
    in
    {
      imports = with self.modules.homeManager; [ ssh ] ++ (with self.modules.generic; [ constants ]);

      home = {
        homeDirectory = "/home/${user}";
        stateVersion = "24.11";
      };
    };
}
