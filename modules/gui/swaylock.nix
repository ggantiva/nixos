{ self, inputs, ... }:
{
  flake.modules.nixos.swaylock =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [ noto-fonts ];
      hj = {
        files.".config/swaylock/config".text = ''
          ignore-empty-password
          font=Noto Sans
          font-size=12
        '';
      };
    };
  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme;

      text = clr.base05;
      bg = clr.base00;
      positive = clr.base0B;
      negative = clr.base08;
      ring = clr.base01;
    in
    {
      hj.files.".config/swaylock/config".text = ''
        color=${bg}
        inside-color=${bg}
        inside-clear-color=${bg}
        inside-caps-lock-color=${bg}
        inside-ver-color=${bg}
        inside-wrong-color=${bg}
        key-hl-color=${positive}
        layout-bg-color=${bg}
        layout-border-color=${ring}
        layout-text-color=${text}
        line-uses-inside
        ring-color=${ring}
        ring-clear-color=${negative}
        ring-caps-lock-color=${ring}
        ring-ver-color=${positive}
        ring-wrong-color=${negative}
        separator-color=00000000

        text-color=${text}
        text-clear-color=${text}
        text-caps-lock-color=${text}
        text-ver-color=${text}
        text-wrong-color=${text}
      '';
    };
}
