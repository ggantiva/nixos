{
  flake.modules.nixos.boot = {
    boot = {
      # Enable stage-1 bootloader
      initrd.systemd.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          # Disable kernel editing for security
          editor = false;
          # Disable limit of nixos generations
          configurationLimit = null;
          memtest86.enable = true;
          consoleMode = "max";
        };
      };
    };
  };
}
