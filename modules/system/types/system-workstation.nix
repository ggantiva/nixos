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
        fuzzel
        osd
        swaylock
        swayidle

        base16
        gtk
        librewolf

        nvf
        git
        zoxide
        zathura
      ];

      environment.systemPackages = with pkgs; [
        vesktop
        lazygit
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
  flake.modules.homeManager.system-workstation = {
    imports = with self.modules.homeManager; [
      system-base

      base16
      fzf
      zoxide
    ];
  };
        foot
        mako
        btop
}
