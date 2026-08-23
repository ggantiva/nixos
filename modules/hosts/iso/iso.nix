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
        ../../users/id_green.pub
        ../../users/id_blue.pub
      ];

      nix.settings.experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
}
