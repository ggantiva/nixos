{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        core = {
          compression = 9;
          preloadindex = true;
        };

        init = {
          defaultBranch = "main";
        };

        user = {
          name = "Germán Gantiva";
          email = "pm@ggantiva.com";
        };
      };
    };
  };
}
