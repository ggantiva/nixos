{ self, ... }:
{
  flake.modules.nixos.hp705 =
    { lib, pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        system-cli
        openssh
        ggantiva

        media-server
        caddy
        vaultwarden
        searx
        homepage
        speedtest
      ];

      home-manager.users.ggantiva.imports = with self.modules.homeManager; [
        system-cli
      ];

      networking = {
        hostName = "hp705";
      };

      users.users.backup = {
        isSystemUser = true;
        group = "backup";
        home = "/var/empty";
        createHome = false;
        shell = "${pkgs.bash}/bin/bash";
        openssh.authorizedKeys.keys = [
          ''command="${pkgs.rrsync}/bin/rrsync -ro -absolute /data/backups",no-pty,no-agent-forwarding ${lib.trim (builtins.readFile ../../users/id_backup.pub)}''
        ];
      };

      users.groups.backup = { };

      systemd.tmpfiles.rules = [
        "A+ /data/backups - - - - d:u:backup:r-X,u:backup:r-X"
      ];
    };
}
