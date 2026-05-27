{
  flake.modules.homeManager.librewolf = {
    programs.librewolf = {
      enable = true;
      languagePacks = [
        "en-US"
        "es-MX"
      ];

      profiles."default".settings = {
        "privacy.clearOnShutdown.history" = false;
        "middlemouse.paste" = false;
        "browser.fullscreen.autohide" = false;
        "browser.search.separatePrivateDefault.ui.enabled" = false;
        "browser.search.separatePrivateDefault" = false;
      };

      policies = {
        SearchEngines = {
          Default = "Searx";
          PreventInstall = true;
          Add = [
            {
              Name = "Nix Packages";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              Alias = "@np";
            }
            {
              Name = "NixOS Options";
              URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              Alias = "@no";
            }
            {
              Name = "Home Manager Options";
              URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}&source=home_manager";
              Alias = "@hm";
            }
            {
              Name = "Searx";
              URLTemplate = "https://searx.ggantiva.com/?q={searchTerms}";
              Alias = "@sx";
            }
          ];
        };

        # See https://mozilla.github.io/policy-templates/#extensionsettings
        # Check about:support for extension id
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below

          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # Sponsorblock
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # SurfingKeys
          "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/surfingkeys_ff/";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # Darkreader
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # Unhook
          "myallychou@gmail.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          # Linkding
          "{61a05c39-ad45-4086-946f-32adb0a40a9d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/linkding-extension/";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
      };
    };
  };
}
