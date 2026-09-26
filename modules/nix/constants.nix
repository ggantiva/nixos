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
          url = "https://w.wallhaven.cc/full/3l/wallhaven-3l3lzd.png";
          hash = "sha256-2+RbpDG1rPGG2vkKzuVAN7Mhg9uPqS3fTwA97BLvhBg=";
        };
      };
    };
}
