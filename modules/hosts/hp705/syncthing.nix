{ self, ... }:
{
  flake.modules.nixos.hp705 =
    { config, ... }:
    let
      syn = config.services.syncthing;
    in
    {
      imports = with self.modules.nixos; [ syncthing ];

      services.syncthing = {
        cert = config.sops.secrets."syncthing/hp705/cert.pem".path;
        key = config.sops.secrets."syncthing/hp705/key.pem".path;

        dataDir = "/data/syncthing/";

        settings = {
          folders = {
            "Notes" = {
              path = "${syn.dataDir}/Notes";
              devices = [
                "h610m"
                "oppoa54"
              ];
            };

            "Documents" = {
              path = "${syn.dataDir}/Documents";
              devices = [
                "h610m"
                "oppoa54"
              ];
            };
          };
        };
      };

      sops.secrets = {
        "syncthing/hp705/cert.pem" = {
          owner = config.services.syncthing.user;
          mode = "0600";
        };

        "syncthing/hp705/key.pem" = {
          owner = config.services.syncthing.user;
          mode = "0600";
        };
      };
    };

  flake.modules.nixos.syncthing = {
    services.syncthing.settings.devices = {
      hp705 = {
        id = "IROUXZQ-M3ISI6B-O3EGOF7-OLKSBUR-VYOCTIN-RVOS3UH-RFL5LBA-TTYWWAE";
      };
    };
  };
}
