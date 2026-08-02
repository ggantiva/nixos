{ self, ... }:
{
  flake.modules.nixos.hp705 = {pkgs,...}:{
    imports = with self.modules.nixos; [
      system-base
      zfs
      openssh

      project-zomboid
      media-server
      miniflux
      linkding
      admin
      caddy
      vaultwarden
      searx
    ];

        # Rollback root on boot
        boot.initrd.systemd = {
          enable = true;
          services.initrd-rollback-root = {
            after = [ "zfs-import-zroot.service" ];
            wantedBy = [ "initrd.target" ];
            before = [ "sysroot.mount" ];
            path = [ pkgs.zfs ];
            description = "Rollback root";
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = "zfs rollback -r zroot/root@blank";
          };
        };


    networking = {
      hostName = "hp705";
      # Needed for ZFS
      hostId = "c9a6bac4";
    };
  };
}
