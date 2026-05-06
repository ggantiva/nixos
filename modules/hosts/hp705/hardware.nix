{ self, inputs, ... }:
{
  flake.modules.nixos.hp705 =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "r8169" ]; # Network
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      # Enable ssh
      boot.initrd.network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2428;
          hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
          authorizedKeyFiles = [
            ../../system/id_blue.pub
            ../../system/id_green.pub
          ];
        };
      };

      # Not needed with LUKS
      boot.zfs.requestEncryptionCredentials = false;
      boot.zfs.forceImportRoot = false;

      boot.initrd.luks.devices = {
        cryptroot = {
          device = "/dev/disk/by-uuid/6fa3a51e-a756-4f1c-aa96-acde85f8900a";
          allowDiscards = true;
          preLVM = true;
        };
      };

      fileSystems."/" = {
        device = "zroot/root";
        fsType = "zfs";
      };

      fileSystems."/home" = {
        device = "zroot/home";
        fsType = "zfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/18B4-4DD4";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      fileSystems."/nix" = {
        device = "zroot/nix";
        fsType = "zfs";
      };

      fileSystems."/persist" = {
        device = "zroot/persist";
        fsType = "zfs";
        neededForBoot = true;
      };

      swapDevices = [
        {
          device = "/dev/disk/by-partuuid/e5931997-9e32-4616-ae1f-90a341dfdae4";
          randomEncryption = {
            enable = true;
            allowDiscards = true;
          };
        }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
