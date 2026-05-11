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
          url = "https://w.wallhaven.cc/full/vg/wallhaven-vgyjo3.jpg";
          hash = "sha256-Xc4OeYUZRWGy79sc5yDXJgPhC669zK6iwGKQ395Y+uM=";
        };
      };
    };
}
