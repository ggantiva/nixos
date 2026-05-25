{ self, ... }:
let
  user = "admin";
in
{
  flake.modules.nixos.${user} = {
    users = {
      mutableUsers = false;
      users.${user} = {
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$Azdmw8tO4lu5Ed9costZm1$KrD8XDq/Ht9417VaDuswaxbH9ctpZzIsobfeQMhHNY9";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keyFiles = [
          ./id_blue.pub
          ./id_green.pub
        ];
      };
    };

    home-manager.users."${user}" = {
      imports = [ self.modules.homeManager.${user} ];
    };
  };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      system-base
    ];

    home = {
      username = "${user}";
    };
  };
}
