{
  flake.modules.nixos.podman = { config, ... }: {
    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
      };
    };

    users.users.${config.constants.user} = {
      extraGroups = [ "podman" ];
    };

    custom.impermanence.root.directories = [ "/var/lib/containers" ];
  };
}
