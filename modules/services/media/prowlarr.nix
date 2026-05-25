{
  flake.modules.nixos.prowlarr =
    { lib, ... }:
    let
      port = 9696;
      url = "prowlarr";
    in
    {
      services.prowlarr = {
        enable = true;
        settings = {
          server = {
            inherit port;
          };
        };
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @${url} host ${url}.ggantiva.com
        handle @${url} {
          reverse_proxy localhost:${toString port}
        }
      '';

      custom.impermanence.root.directories = [ "/var/lib/private/prowlarr" ];

      # Avoids issues with permissions https://github.com/nix-community/impermanence/issues/254
      systemd.services."systemd-tmpfiles-resetup" = {
        serviceConfig = {
          RemainAfterExit = lib.mkForce false;
        };
      };
    };
}
