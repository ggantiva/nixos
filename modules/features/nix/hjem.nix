{ inputs, ... }:
{
  flake.modules.nixos.hjem =
    { lib, config, ... }:
    let
      inherit (config.constants) user;
    in
    {
      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" user ])
      ];

      hjem = {
        clobberByDefault = true;
      };

      hj = {
        enable = true;
        user = "${user}";
        clobberFiles = true;
        directory = "/home/${user}";
      };
    };
}
