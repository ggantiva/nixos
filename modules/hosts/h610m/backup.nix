{ ... }:
{
  flake.modules.nixos.h610m =
    { config, pkgs, ... }:
    let
      user = config.constants.user;
      backupScript = pkgs.writeShellScript "pull-backups" ''
        set -euo pipefail
        TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H%M%S)
        DEST="/home/${user}/Backups"

        ${pkgs.coreutils}/bin/mkdir -p "$DEST"

        ${pkgs.rsync}/bin/rsync -avz --delete \
          --exclude='/.history' \
          --backup --backup-dir="$DEST/.history/$TIMESTAMP" \
          -e "${pkgs.openssh}/bin/ssh -p 2428 -i /home/${user}/.ssh/id_backup -o StrictHostKeyChecking=accept-new" \
          backup@192.168.5.4:/data/backups/ \
          "$DEST/"

        # Prune history snapshots older than 90 days
        if [ -d "$DEST/.history" ]; then
          ${pkgs.findutils}/bin/find "$DEST/.history" -mindepth 1 -maxdepth 1 -type d -mtime +90 -exec rm -rf {} +
        fi
      '';
    in
    {
      environment.systemPackages = [ pkgs.rsync ];

      systemd.services.pull-backups = {
        description = "Pull backups from hp705";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = user;
          ExecStart = "${backupScript}";
        };
      };

      systemd.timers.pull-backups = {
        description = "Run pull-backups periodically";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "1h";
          Persistent = true;
        };
      };
    };
}
