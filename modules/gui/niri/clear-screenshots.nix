{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      clear-screenshots = pkgs.writeShellApplication {
        name = "clear-screenshots";

        runtimeInputs = with pkgs; [
          coreutils
          findutils
        ];

        text = /* bash */ ''
          set -euo pipefail

          DIR="$HOME/Pictures/Screenshots"

          # Ensure the target directory exists.
          if [[ ! -d "$DIR" ]]; then
              echo "Error: directory does not exist: $DIR" >&2
              exit 1
          fi

          # Calculate the cutoff timestamp: one week ago.
          CUTOFF=$(date -d '1 week ago' '+%s')

          find "$DIR" -maxdepth 1 -type f -print0 |
          while IFS= read -r -d "" file; do
              # Birth time in seconds since Unix epoch.
              BIRTH_TIME=$(stat -c '%W' "$file")

              # %W returns 0 if birth time is unavailable.
              if [[ "$BIRTH_TIME" -eq 0 ]]; then
                  echo "Skipping (birth time unavailable): $file" >&2
                  continue
              fi

              if (( BIRTH_TIME < CUTOFF )); then
                  echo "Deleting: $file"
                  rm -- "$file"
              fi
          done
        '';
      };
    in
    {
      systemd.user = {
        timers.clear-screenshots = {
          Unit = {
            Description = "Clears screenshots after boot";
          };

          Timer = {
            OnBootSec = "2min";
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };
        };

        services.clear-screenshots = {
          Unit = {
            Description = "Clears screenshots older than 1 week";
          };

          Service = {
            ExecStart = "${clear-screenshots}/bin/clear-screenshots";
          };
        };
      };
    };
}
