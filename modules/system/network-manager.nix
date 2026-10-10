{
  flake.modules.nixos.network-manager = { config, ... }: {
    networking.networkmanager.enable = true;

    programs.nm-applet.enable = true;

    users.users.${config.constants.user}.extraGroups = [ "networkmanager" ];
  };
}
