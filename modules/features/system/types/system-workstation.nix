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

        base16
        librewolf
        fzf
        zathura
      ];

      environment.systemPackages = with pkgs; [
        vesktop
      ];
    };
}
