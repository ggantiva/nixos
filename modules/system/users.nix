{ self, inputs, ... }:
{
  flake.modules.nixos.users =
    { config, ... }:
    let
      inherit (config.constants) user;
    in
    {
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
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keyFiles = [
              ./id_blue.pub
              ./id_green.pub
            ];
          };
        };
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

      hj.files = {
        ".ssh/id_blue.pub".source = ./id_blue.pub;
        ".ssh/id_green.pub".source = ./id_green.pub;
      };
    };
}
