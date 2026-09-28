{
  flake.modules.homeManager.git = { config, ... }: {
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
          email = "dev@${config.constants.domain}";
        };
      };
    };
  };
}
