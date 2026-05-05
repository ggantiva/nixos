{ self, ... }:
{
  flake.modules.nixos.iso =
    { pkgs, ... }:
    {
      boot.loader.grub.memtest86.enable = true;

      # Enable SSH
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
      users.users.root.openssh.authorizedKeys.keyFiles = [
        ../../system/id_blue.pub
        ../../system/id_green.pub
      ];

      nix.settings.experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
}
