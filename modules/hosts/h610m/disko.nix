{ inputs, ... }:
{
  flake.modules.nixos.h610m = {
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

	disk.main = {
	  type = "disk";
	  device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22101V450705";
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

	      luks = {
	        size = "100%";
		content = {
		  type = "luks";
		  name = "crypted";
		  settings.allowDiscards = true;
		  enrollFido2 = true;
		  # Do not wait for recovery displaying and blocking formatting.
		  enrollRecovery = false;
		  content = {
		    type = "btrfs";
		    extraArgs = [ "-f" ];

		    subvolumes = {
		      "/persist" = {
		        mountOptions = ["subvol=persist" "noatime"];
			mountpoint = "/persist";
		      };

		      "/nix" = {
		        mountOptions = ["subvol=nix" "noatime"];
			mountpoint = "/nix";
		      };

		      "/home" = {
		        mountOptions = ["subvol=home" "noatime"];
			mountpoint = "/home";
		      };
		    };
		  };
		};
	      };
	    };
	  };
	};
    };
  };
}
