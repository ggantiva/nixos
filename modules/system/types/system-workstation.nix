{ self, ... }:
{
  flake.modules.nixos.system-workstation =
    { pkgs, config, ... }:
    {
      imports = with self.modules.nixos; [
        system-cli
        pipewire
        yubikey
        network-manager

        greetd
        niri
        swaylock
      ];

      sops.secrets = {
        "private_keys/blue" = {
          path = "/home/${config.constants.user}/.ssh/id_blue";
          owner = "${config.constants.user}";
        };

        "private_keys/green" = {
          path = "/home/${config.constants.user}/.ssh/id_green";
          owner = "${config.constants.user}";
        };

        "private_keys/backup" = {
          path = "/home/${config.constants.user}/.ssh/id_backup";
          owner = "${config.constants.user}";
        };
      };

      fonts = {
        packages = with pkgs; [
          liberation_ttf
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          unifont
          nerd-fonts.agave
        ];
        enableDefaultPackages = true;
      };
    };

  flake.modules.homeManager.system-workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        system-cli
        base16

        niri
        kitty
        fuzzel
        zathura
        osd
        librewolf
        gtk
        swaybg

        wl-clipboard
        yazi
        fzf
        zoxide
        btop
        git
        nvim
        thunderbird
      ];

      home.packages = with pkgs; [
        wiremix
        vesktop
        lazygit
        bottles
        openspec
        antigravity-cli
        quickshell
      ];
    };
}
