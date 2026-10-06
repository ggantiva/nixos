{
  flake.modules.homeManager.thunderbird = {
    programs.thunderbird = {
      enable = true;
      languagePacks = [
        "es-MX"
        "en-US"
      ];
    };
  };
}
