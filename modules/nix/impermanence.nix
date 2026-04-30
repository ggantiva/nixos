{ self, inputs, ... }:
{
  flake.modules.nixos.impermanence =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types unique;
      inherit (types) listOf str;
      cfg = config.custom.impermanence;
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.custom.impermanence = {
        root = {
          directories = mkOption {
            type = listOf str;
            default = [ ];
            description = "Directories to persist in root directory.";
          };

          files = mkOption {
            type = listOf str;
            default = [ ];
            description = "Files to persist in root directory.";
          };
        };
      };

      config = {
        # Disable sudo introduction
        security.sudo.extraConfig = "Defaults lecture=never";

        users.mutableUsers = false;

        # Rollback root on boot
        boot.initrd.systemd = {
          enable = true;
          services.initrd-rollback-root = {
            after = [ "zfs-import-zroot.service" ];
            wantedBy = [ "initrd.target" ];
            before = [ "sysroot.mount" ];
            path = [ pkgs.zfs ];
            description = "Rollback root";
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = "zfs rollback -r zroot/root@blank";
          };
        };

        environment.persistence."/persist" = {
          hideMounts = true;

          directories = unique (
            [
              "/var/lib/nixos"
              "/var/lib/systemd"
            ]
            ++ cfg.root.directories
          );

          files = unique (
            [
              "/etc/machine-id"
              "/etc/ssh/ssh_host_rsa_key"
              "/etc/ssh/ssh_host_rsa_key.pub"
              "/etc/ssh/ssh_host_ed25519_key"
              "/etc/ssh/ssh_host_ed25519_key.pub"
            ]
            ++ cfg.root.files
          );

        };
      };
    };
}
