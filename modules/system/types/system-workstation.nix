{self, ...}: {
  flake.modules.nixos.system-workstation = {pkgs, ...}: {
    imports = with self.modules.nixos; [
      system-base
      pipewire
      yubikey

      greetd
      niri
      swaylock
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

  flake.modules.homeManager.system-workstation = {pkgs, ...}: {
    imports = with self.modules.homeManager; [
      system-base
      base16

      kittybg
      niri
      kitty
      fuzzel
      zathura
      mako
      osd
      librewolf
      gtk

      yazi
      fzf
      zoxide
      btop
      git
      nvim
    ];

    home.packages = with pkgs; [
      wl-clipboard
      wiremix
      vesktop
      lazygit
    ];
  };
}
