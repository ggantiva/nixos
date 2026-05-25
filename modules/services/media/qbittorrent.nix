{
  flake.modules.nixos.qbittorrent =
    { lib, pkgs, ... }:
    let
      webuiPort = 9091;
      url = "torrent";
      profileDir = "/var/lib/qBittorrent/";
      DefaultSavePath = "/misc/media-server/torrents/";
      user = "qbittorrent";
      group = "media";
    in
    {
      services.qbittorrent = {
        enable = true;
        inherit webuiPort;
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
            AlternativeUIEnabled = true;
            RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
            Password_PBKDF2 = "@ByteArray(81hDQhW898bx7J6YVDQqug==:PxQ+tjI064ZYLsoEv/17ZV7DI4sYv70VN7Rg474CepQugoCHXXe+SrzQDcoxU2A6OQDONYPadKMxIRFjlL4ebg==)";
          };
        };
      };

      services.caddy.virtualHosts."*.ggantiva.com".extraConfig = ''
        @${url} host ${url}.ggantiva.com
        handle @${url} {
          reverse_proxy localhost:${toString webuiPort}
        }
      '';

      # Avoids issues with permissions https://github.com/nix-community/impermanence/issues/254
      systemd.services."systemd-tmpfiles-resetup" = {
        serviceConfig = {
          RemainAfterExit = lib.mkForce false;
        };
      };

      custom.impermanence.root.directories = [ profileDir ];
    };
}
