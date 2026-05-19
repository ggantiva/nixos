{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = "lone";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "lone" ];
            })
          ];
        };

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    };
}
