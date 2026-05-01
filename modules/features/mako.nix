{ self, inputs, ... }:
{
  flake.modules.nixos.mako =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [ noto-fonts ];
      environment.systemPackages = with pkgs; [ mako ];
      hj = {
        files.".config/mako/config".text = ''
          default-timeout=8000
          font=Noto Sans 12
          border-size=3
          border-radius=3
        '';
      };
    };

  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      hj.files.".config/mako/config".text = ''
        text-color=${clr.base05}
        background-color=${clr.base01}e6
        border-color=${clr.base08}
        progress-color=over ${clr.base08}e6
      '';
    };
}
