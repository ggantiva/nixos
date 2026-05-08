{ self, inputs, ... }:
{
  flake.modules.nixos.zathura =
    { pkgs, ... }:
    {
      hj = {
        packages = with pkgs; [ zathura ];
        files.".config/zathura/zathurarc".text = ''
          set recolor true
          set recolor-reverse-video true
          set recolor-keephue true
        '';
      };

    };

  flake.modules.nixos.base16 =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      hj.files.".config/zathura/zathurarc".text = ''
        set default-bg "${clr.base00}"
        set default-fg "${clr.base01}"

        set statusbar-fg "${clr.base04}"
        set statusbar-bg "${clr.base02}"

        set inputbar-bg "${clr.base00}"
        set inputbar-fg "${clr.base07}"

        set notification-bg "${clr.base00}"
        set notification-fg "${clr.base07}"
        set notification-error-bg "${clr.base00}"
        set notification-error-fg "${clr.base08}"
        set notification-warning-bg "${clr.base00}"
        set notification-warning-fg "${clr.base08}"

        set highlight-color "${clr.base0A}"
        set highlight-active-color "${clr.base0D}"

        set completion-bg "${clr.base01}"
        set completion-fg "${clr.base0D}"
        set completion-highlight-fg "${clr.base07}"
        set completion-highlight-bg "${clr.base0D}"

        set recolor-lightcolor "${clr.base00}"
        set recolor-darkcolor "${clr.base06}"
      '';
    };
}
