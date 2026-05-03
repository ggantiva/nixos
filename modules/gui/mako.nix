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

  flake.modules.nixos.osd = {
    hj.files.".config/mako/config".text = ''
      [app-name=wp-vol]
      layer=overlay
      history=0
      anchor=bottom-center
      group-by=app-name
      format=<b>%s</b>\n%b

      outer-margin=30
      width=250

      [app-name=togglemicrophone]
      layer=overlay
      history=0
      anchor=bottom-center
      group-by=app-name
      format=<b>%s</b>\n%b

      width=50
      border-size=3
      border-radius=0

      text-alignment=center

      [app-name=clock]
      layer=overlay
      history=0
      anchor=top-center
      group-by=app-name
      format=<b>%s</b>\n%b

      width=125
      border-size=3
      border-radius=3

      text-alignment=center

      [app-name=volume group-index=0]
      invisible=0
    '';
  };

  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      hj.files.".config/mako/config".text = ''
        text-color=${clr.base05}
        background-color=${clr.base01}
        border-color=${clr.base08}
        progress-color=over ${clr.base08}e6

        [app-name=wp-vol]
        text-color=${clr.base01}
      '';
    };
}
