{
  flake.modules.nixos.linkding =
    { config, ... }:
    let
      port = 9099;
      dataDir = "/var/lib/linkding";
    in
    {
      services.linkding = {
        enable = true;
        openFirewall = true;
        inherit port;
        inherit dataDir;
        settings = {
          LD_SUPERUSER_NAME = "admin";
        };

        environmentFile = config.sops.secrets.linkding-passwd.path;
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @linkding host linkding.ggantiva.com
          handle @linkding {
            reverse_proxy localhost:${toString port}
          }
      '';

      sops.secrets.linkding-passwd = { };

      custom.impermanence.root.directories = [ dataDir ];
    };
}
