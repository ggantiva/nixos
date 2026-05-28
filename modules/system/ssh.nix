{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          identityAgent = "none";
          forwardAgent = false;
          addKeysToAgent = "yes";

          serverAliveInterval = 0;
          serverAliveCountMax = 3;

          identitiesOnly = true;
          compression = true;

          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";

          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = [
            "~/.ssh/id_green"
            "~/.ssh/id_blue"
          ];
        };

        "hp705" = {
          hostname = "192.168.5.4";
          port = 2428;
          user = "ggantiva";
          identityFile = [
            "~/.ssh/id_green"
            "~/.ssh/id_blue"
          ];
        };
      };
    };
  };
}
