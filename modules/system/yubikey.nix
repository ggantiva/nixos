{
  flake.modules.nixos.yubikey =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yubioath-flutter
        pam_u2f
      ];

      # Required for usb detection
      services.pcscd.enable = true;

      # Touch notifications
      programs.yubikey-touch-detector.enable = true;
    };
}
