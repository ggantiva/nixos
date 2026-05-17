{
  flake.modules.nixos.syncthing = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;

      overrideDevices = true;
      overrideFolders = true;

      settings.devices = {
        oppoa54.id = "W7VV2FD-SPIPGBE-PGSKH3M-F4RINCI-2O6CBMC-C7BCBXN-H7L2JKF-M5NHMAK";
      };
    };
  };
}
