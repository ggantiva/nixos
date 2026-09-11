{
  flake.modules.nixos.niri =
    { pkgs, ... }:
    let
      nixpkgs-a5cbcfe9 = builtins.getFlake "github:NixOS/nixpkgs/a5cbcfe954791221bfffe2307f7d1a1bf61a871e";

      xwayland-satellite =
        nixpkgs-a5cbcfe9.legacyPackages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite;
    in
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
    };

  flake.modules.homeManager.niri =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      home = {
        file = {
          ".config/niri/" = {
            source = ./config;
            recursive = true;
          };
          ".config/niri/theme.kdl".text = ''
            layout {
              background-color "${clr.base00}"

              shadow {
                color "${clr.base00}"
              }

              focus-ring {
                active-color "${clr.base08}"
              }

              tab-indicator {
                active-color "${clr.base09}"
              }

              insert-hint {
                color "${clr.base08}"
              }
            }
          '';
        };
      };
    };
}
