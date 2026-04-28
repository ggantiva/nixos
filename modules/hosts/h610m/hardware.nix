{ self, inputs, ... }:
{
  flake.modules.nixos.h610m-hardware =
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
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      boot.initrd.luks.devices = {
        LUKS = {
          device = "/dev/disk/by-uuid/10bc7f6b-122c-49fd-b2cd-34daeac644d8";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          allowDiscards = true;
          preLVM = true;
        };
      };

      # Not needed with LUKS
      boot.zfs.requestEncryptionCredentials = false;

      fileSystems."/" = {
        device = "zroot/root";
        fsType = "zfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/4377-92CE";
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

      fileSystems."/home" = {
        device = "zroot/home";
        fsType = "zfs";
      };

      fileSystems."/persist" = {
        device = "zroot/persist";
        fsType = "zfs";
        neededForBoot = true;
      };

      swapDevices = [
        {
          device = "/dev/disk/by-partuuid/6a9e625d-cd3f-43e6-9996-f026f1904511";
          randomEncryption = {
            enable = true;
            allowDiscards = true;
          };
        }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
