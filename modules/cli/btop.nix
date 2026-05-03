{ self, inputs, ... }:
{
  flake.modules.nixos.btop =
    { pkgs, ... }:
    {
      hj = {
        packages = with pkgs; [ btop ];
        files.".config/btop/btop.conf".text = ''
          theme_background=false
          vim_keys=true
          update_ms=1000
          clock_format="%I:%M %p"
          color_theme="TTY"
        '';
      };
    };
}
