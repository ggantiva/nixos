{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
      environment = {
        systemPackages = with pkgs; [ protonup-ng ];

        sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
      };
    };
}
