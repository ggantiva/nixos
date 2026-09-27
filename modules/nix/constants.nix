{
  flake.modules.generic.constants =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.constants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.constants = {
        user = "ggantiva";
        wallpaper = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/21/wallhaven-216z59.jpg";
          hash = "sha256-V4TLEDHMLVezADMwbclK2MIZK2c3w3EumaSXg35ntG8=";
        };
      };
    };
}
