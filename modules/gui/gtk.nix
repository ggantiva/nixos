{
  flake.modules.homeManager.gtk =
    { pkgs, config, ... }:
    {
      gtk = {
        enable = true;

        theme.name = "Adwaita";
        colorScheme = "dark";

        iconTheme = {
          package = pkgs.morewaita-icon-theme;
          name = "MoreWaita";
        };

        font = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
          size = 12;
        };

        gtk4.theme = config.gtk.theme;
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
