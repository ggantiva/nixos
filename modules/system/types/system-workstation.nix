{ self, ... }:
{
  flake.modules.nixos.system-workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        system-base
        pipewire
        yubikey

        ly
        niri
        swaybg
        osd
        swaylock
        swayidle

        base16
        gtk
        librewolf

        nvf
        git
      ];

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
        system-base

        base16

        foot
        fuzzel
        zathura
        mako

        fzf
        zoxide
        btop
      ];

      home.packages = with pkgs; [
        vesktop
        lazygit
      ];
    };
}
