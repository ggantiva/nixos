{self, ...}: let
  user = "ggantiva";
in {
  flake.modules.nixos.users = {
    users = {
      mutableUsers = false;
      users = {
        root = {
          # Disable root user
          initialHashedPassword = "*";
        };

        ${user} = {
          isNormalUser = true;
          initialHashedPassword = "$y$j9T$Azdmw8tO4lu5Ed9costZm1$KrD8XDq/Ht9417VaDuswaxbH9ctpZzIsobfeQMhHNY9";
          extraGroups = ["wheel"];
          openssh.authorizedKeys.keyFiles = [
            ./id_blue.pub
            ./id_green.pub
          ];
        };
      };
    };

    home-manager.users."${user}" = {
      imports = [self.modules.homeManager.${user}];
    };

    sops.secrets = {
      "private_keys/blue" = {
        path = "/home/${user}/.ssh/id_blue";
        owner = "${user}";
      };

      "private_keys/green" = {
        path = "/home/${user}/.ssh/id_green";
        owner = "${user}";
      };
    };
  };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      system-workstation
    ];

    home = {
      username = "${user}";
      file = {
        ".ssh/id_blue.pub".source = ./id_blue.pub;
        ".ssh/id_green.pub".source = ./id_green.pub;
      };
    };
  };
}
