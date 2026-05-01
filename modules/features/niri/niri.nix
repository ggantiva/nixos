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
}
