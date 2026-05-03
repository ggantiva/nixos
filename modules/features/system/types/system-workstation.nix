{ self, ... }:
{
  flake.modules.nixos.system-workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        system-base
        pipewire

        ly
        niri
        swaybg
        foot
        fuzzel
        mako
        osd

        base16
        librewolf

        nvf
        git
        zoxide
        fzf
        zathura
        btop
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
        ];
        enableDefaultPackages = true;
      };
    };
}
