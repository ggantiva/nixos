{ self, inputs, ... }:
{
  flake.modules.nixos.syncthing = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;

      overrideDevices = true;
      overrideFolders = true;
    };
  };
}
