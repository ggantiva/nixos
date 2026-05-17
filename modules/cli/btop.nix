{
  flake.modules.homeManager.btop = {pkgs, ...}: {
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "TTY";
        # Enable transparency
        theme_background = false;
        vim_keys = true;
        update_ms = 1000;
        clock_format = "%I %M %p";
      };
    };
  };
}
