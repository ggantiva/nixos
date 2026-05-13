{
  flake.modules.generic.constants =
    { pkgs, lib, ... }:
    {
      options.constants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.constants = {
        user = "ggantiva";
        wallpaper = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/p2/wallhaven-p25l6j.jpg";
          hash = "sha256-gpsXUpqBFxZaA+vM1p3+3ejOZv1LphlS77s6e0JmBH0=";
        };
      };
    };
}
