{
  perSystem =
    { pkgs, ... }:
    {
      packages.lockscreen = pkgs.writeShellApplication {
        name = "lockscreen";
        runtimeInputs = with pkgs; [
          grim
          imagemagick
          swaylock
        ];
        text = ''
          IMAGE="/tmp/swaylock-bg.png"
          grim "$IMAGE"
          magick "$IMAGE" -scale 10% -blur 0x2.5 -resize 1000% -level 0%,100%,0.8 "$IMAGE"
          swaylock --daemonize -i "$IMAGE"
        '';
      };
    };
}
