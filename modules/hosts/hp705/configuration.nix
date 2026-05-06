{ self, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = with self.modules.nixos; [
      system-base
      openssh

      caddy
      vaultwarden
      searx
    ];

    networking = {
      hostName = "hp705";
      # Needed for ZFS
      hostId = "c9a6bac4";
    };
  };

  flake.modules.nixos.ssh = {
    hj.files.".ssh/config".text = ''
      Host hp705
        HostName 192.168.5.4 
        Port 2428
        user ggantiva
        IdentityFile ~/.ssh/id_green
        IdentityFile ~/.ssh/id_blue
    '';
  };
}
