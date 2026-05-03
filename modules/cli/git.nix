{ self, inputs, ... }:
{
  flake.modules.nixos.git = {
    programs.git = {
      enable = true;
      config = {
        core = {
          compression = 9;
          preloadindex = true;
        };

        user = {
          name = "Germán Gantiva";
          email = "pm@ggantiva.com";
        };

        init.defaultBranch = "main";
      };
    };

    hj.files = {
      ".ssh/config".text = ''
        AddKeysToAgent yes
        IdentitiesOnly yes
        IdentityAgent none

        Host codeberg.org
          HostName codeberg.org
          user git
          IdentityFile ~/.ssh/id_green
          IdentityFile ~/.ssh/id_blue
      '';
    };
  };
}
