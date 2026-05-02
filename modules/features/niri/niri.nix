{ self, inputs, ... }:
{
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        useNautilus = false;
      };

      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        systemPackages = with pkgs; [
          simp1e-cursors
          xwayland-satellite
        ];
      };

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      xdg.portal.config.niri."org.freedesktop.imp.portal.FileChooser" = [ "gtk" ];

      hj.files.".config/niri/config.kdl".source = ./niri.kdl;
    };

  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      hj.files.".config/niri/theme.kdl".text = ''
        layout {
          background-color "${clr.base00}"

          focus-ring {
            active-color "${clr.base08}"
            width 3
          }

          insert-hint {
            color "${clr.base08}"
          }
        }

        overview {
          zoom 0.25
          backdrop-color "${clr.base00}"
        }

        // Shadow and blur for floating windows
        window-rule {
          match is-floating=true
          background-effect {
            blur true
            xray false
          }

          shadow {
            on
            color "${clr.base00}80"
            draw-behind-window false
            spread 5
            offset x=10 y=10
            softness 15
          }
        }
      '';
    };
}
