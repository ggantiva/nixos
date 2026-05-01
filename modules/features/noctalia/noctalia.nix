{ self, inputs, ... }:
{
  flake.modules.nixos.noctalia =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ noctalia-shell ];
    };
}
