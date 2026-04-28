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
            initialPassword = "${user}";
            extraGroups = [ "wheel" ];
          };
        };
      };
    };
}
