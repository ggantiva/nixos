{
  flake.modules.homeManager.gtk = {pkgs, ...}: {
    gtk = {
      enable = true;

      theme.name = "Adwaita";

      iconTheme = {
        package = pkgs.morewaita-icon-theme;
        name = "MoreWaita";
      };

      font = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
        size = 12;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      # See: https://github.com/nix-community/home-manager/issues/8232
      gtk4.theme = null;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gtk/settings/file-chooser" = {
        startup-mode = "cwd";
      };

      # Disable recent files and history (File chooser)
      "org/gnome/desktop/privacy" = {
        remember-recent-files = false;
      };
    };
  };
}
