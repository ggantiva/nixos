{ self, ... }:
{
  flake.modules.nixos.system-workstation =
    { pkgs, config, ... }:
    {
      imports = with self.modules.nixos; [
        system-cli
        pipewire
        yubikey

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
        mako
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
      ];

      home.packages = with pkgs; [
        wiremix
        vesktop
        lazygit
        bottles
      ];
    };
}
