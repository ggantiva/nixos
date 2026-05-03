{ self, ... }:
{
  flake.modules.nixos.h610m =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        # System type
        system-workstation

        steam
      ];

      networking = {
        hostName = "h610m";
        # Needed for ZFS
        hostId = "a9b2cbfe";
      };

      services.displayManager.autoLogin = {
        enable = true;
        user = config.constants.user;
      };
    };
}
