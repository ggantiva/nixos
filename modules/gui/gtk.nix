{ config, lib, ... }:
{
  flake.modules.nixos.gtk =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [ noto-fonts ];

      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                gtk-theme = "Adwaita";
                color-scheme = "prefer-dark";
                font-name = "Noto Sans 12";
              };
            };
          }
        ];
      };
    };
}
