{self, ...}: {
  flake.modules.nixos.h610m = {config, ...}: let
    syn = config.services.syncthing;
  in {
    imports = with self.modules.nixos; [syncthing];

    services.syncthing = {
      cert = config.sops.secrets."syncthing/h610m/cert.pem".path;
      key = config.sops.secrets."syncthing/h610m/key.pem".path;

      user = "${config.constants.user}";
      group = "users";

      dataDir = "/home/${config.constants.user}";
      configDir = "/home/${config.constants.user}/.config/syncthing";

      settings.folders = {
        "Notes" = {
          path = "${syn.dataDir}/Notes/";
          devices = ["hp705"];
        };

        "Documents" = {
          path = "${syn.dataDir}/Documents/";
          devices = ["hp705"];
        };
      };
    };

    sops.secrets = {
      "syncthing/h610m/cert.pem" = {
        owner = config.services.syncthing.user;
        mode = "0600";
      };

      "syncthing/h610m/key.pem" = {
        owner = config.services.syncthing.user;
        mode = "0600";
      };
    };
  };

  flake.modules.nixos.syncthing = {
    services.syncthing.settings.devices = {
      h610m = {
        id = "YKJ2OD2-LTR4SON-P6JIOLJ-AFANF6U-BG2QZT3-J3YKLWJ-3GOR3YI-5QOADQX";
      };
    };
  };
}
