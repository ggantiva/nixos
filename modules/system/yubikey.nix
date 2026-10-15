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

  flake.modules.homeManager.mako = {
    services.mako.settings = {
      "app-name=yubikey-touch-detector" = {
        layer = "overlay";
        anchor = "center";
        text-alignment = "center";
        ignore-timeout = 1;
        default-timeout = 4000;
        history = 0;
      };
    };
  };
}
