{ self, inputs, ... }:
{
  flake.modules.nixos.system-workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        system-base

        niri
        swaybg
        foot
        fuzzel
        mako

        base16
        librewolf

        zoxide
        fzf
        zathura
      ];

      environment.systemPackages = with pkgs; [
        vesktop
        lazygit
        btop
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
