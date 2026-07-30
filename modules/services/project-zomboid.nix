# The server must be run once manually to set the admin password
# sudo -u zomboid steam-run /var/lib/zomboid/start-server.sh
{
  flake.modules.nixos.project-zomboid =
    { pkgs, ... }:
    let
      serverDirectory = "/var/lib/zomboid/";
    in
    {
      users.users.zomboid = {
        isSystemUser = true;
        group = "zomboid";
        home = serverDirectory;
        createHome = true;
      };

      users.groups.zomboid = { };

      networking.firewall.allowedUDPPorts = [
        16261
        16262
      ];

      systemd.services.zomboid = {
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${serverDirectory} \
            +login anonymous \
            +app_update 380870 \
            validate \
            +quit
        '';

        script = ''
          ${pkgs.steam-run}/bin/steam-run ${serverDirectory}start-server.sh
        '';

        serviceConfig = {
          PrivateTmp = true;
          Nice = "-5";
          Restart = "always";
          User = "zomboid";
          WorkingDirectory = serverDirectory;
        };
      };

      custom.impermanence.root.directories = [ serverDirectory ];
    };
}
