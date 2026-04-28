{ self, ... }:
{
  flake.modules.nixos.h610m-config = {
    imports = with self.modules.nixos; [
      # Hardware configuration
      h610m-hardware

      # System type
      system-base
    ];

    networking = {
      hostName = "h610m";
      # Needed for ZFS
      hostId = "a9b2cbfe";
    };
  };
}
