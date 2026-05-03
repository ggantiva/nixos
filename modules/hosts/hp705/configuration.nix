{ self, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = with self.modules.nixos; [
      system-base
    ];

    networking = {
      hostName = "hp705";
      # Needed for ZFS
      hostId = "c9a6bac4";
    };
  };
}
