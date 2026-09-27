{
  flake.modules.nixos.qbittorrent =
    {
      config,
      lib,
      ...
    }:
    let
      port = 9091;
      subdomain = "torrent";
      domain = "${subdomain}.${config.constants.domain}";
      profileDir = "/var/lib/qBittorrent/";
      DefaultSavePath = "/data/media/torrents/";
      user = "qbittorrent";
      group = "media";
    in
    {
      services.qbittorrent = {
        enable = true;
        webuiPort = port;
        inherit user;
        inherit group;
        serverConfig = {
          LegalNotice.Accepted = true;

          BitTorrent.Session = {
            inherit DefaultSavePath;
            BTProtocol = "TCP";

            DisableAutoTMMByDefault = false;
            DisableAutoTMMTriggers = {
              CategoryChanged = false;
              CategorySavePathChanged = false;
              DefaultSavePathChanged = false;
            };

            Preallocation = true;
          };

          Core.AutoDeleteAddedTorrentFile = "Always";

          Preferences.WebUI = {
            Password_PBKDF2 = "@ByteArray(81hDQhW898bx7J6YVDQqug==:PxQ+tjI064ZYLsoEv/17ZV7DI4sYv70VN7Rg474CepQugoCHXXe+SrzQDcoxU2A6OQDONYPadKMxIRFjlL4ebg==)";
          };
        };
      };

      services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
        @${subdomain} host ${domain}
        handle @${subdomain} {
          reverse_proxy localhost:${toString port}
        }
      '';

      sops.secrets.homepage-qbittorrent = { };

      custom.homepage = {
        environmentFiles = [ config.sops.secrets.homepage-qbittorrent.path ];
        services.qbittorrent = {
          group = "Media";
          name = "qBittorrent";
          icon = "qbittorrent.png";
          href = "https://${domain}";
          description = "BitTorrent Client";
          siteMonitor = "https://${domain}";
          weight = 5;
          widget = {
            type = "qbittorrent";
            url = "https://${domain}";
            key = "{{HOMEPAGE_VAR_QBITTORENT_KEY}}";
          };
        };
      };

      # Avoids issues with permissions https://github.com/nix-community/impermanence/issues/254
      systemd.services."systemd-tmpfiles-resetup" = {
        serviceConfig = {
          RemainAfterExit = lib.mkForce false;
        };
      };

      custom.impermanence.root.directories = [ profileDir ];
    };
}
