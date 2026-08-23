{ inputs, ... }:
{
  flake.modules.nixos.hp705 = {
    imports = [ inputs.disko.nixosModules.disko ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persist".neededForBoot = true;

    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
          "defaults"
        ];
      };

      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-256G-2006_2351JK403698";
          content = {
            type = "gpt";
            partitions = {
              esp = {
                name = "ESP";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              nixos = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    "/persist" = {
                      mountOptions = [
                        "subvol=persist"
                        "noatime"
                      ];
                      mountpoint = "/persist";
                    };

                    "/nix" = {
                      mountOptions = [
                        "subvol=nix"
                        "noatime"
                      ];
                      mountpoint = "/nix";
                    };

                    "/home" = {
                      mountOptions = [
                        "subvol=home"
                        "noatime"
                      ];
                      mountpoint = "/home";
                    };
                  };
                };
              };
            };
          };
        };

        two = {
          type = "disk";
          device = "/dev/disk/by-id/ata-WDC_WD5000AZLX-60K2TA0_WD-WCC6Z0XZ4ZPE";
          content = {
            type = "gpt";
            partitions = {
              raid = {
                size = "100%";

                content = {
                  type = "mdraid";
                  name = "data";
                };
              };
            };
          };
        };

        three = {
          type = "disk";
          device = "/dev/disk/by-id/ata-WDC_WD5000LPZX-08Z10_WD-WXG2E2139173";
          content = {
            type = "gpt";
            partitions = {
              raid = {
                size = "100%";
                content = {
                  type = "mdraid";
                  name = "data";
                };
              };
            };
          };
        };

        mdadm = {
          data = {
            type = "mdadm";
            level = 1;
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}
