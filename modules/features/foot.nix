{ self, inputs, ... }:
{
  flake.modules.nixos.foot =
    { pkgs, ... }:
    {
      hj = {
        packages = with pkgs; [ foot ];
        files."./config/foot/foot.ini".text = ''
          [main]
          font=Agave Nerd Font Mono:size=13.5
          pad=4x4 center
          selection-target=clipboard

          [cursor]
          beam-thickness=2px
          style=beam
          unfocused-style=none
        '';
      };
    };
}
