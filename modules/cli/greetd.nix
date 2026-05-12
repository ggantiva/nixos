{
  flake.modules.nixos.greetd =
    { pkgs, config, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          initial_session = {
            command = "${pkgs.niri}/bin/niri-session";
            user = "${config.constants.user}";
          };

          default_session = {
            command = "${pkgs.greetd}/bin/agreety --cmd niri-session";
          };
        };
      };
    };
}
