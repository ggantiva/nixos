{ self, inputs, ... }:
{
  flake.modules.nixos.swaybg =
    { pkgs, ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/vg/wallhaven-vgyjo3.jpg";
        hash = "sha256-Xc4OeYUZRWGy79sc5yDXJgPhC669zK6iwGKQ395Y+uM=";
      };
    in
    {
      systemd.user.services.swaybg = {
        description = "Wallpaper Service";
        after = [ "niri.service" ];
        wantedBy = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '${wallpaper}'";
          Restart = "on-failure";
        };
      };
    };
}
