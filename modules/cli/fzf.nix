{
  flake.modules.homeManager.fzf =
    { config, ... }:
    let
      clr = config.scheme.withHashtag;
    in
    {
      programs.bash.enable = true;
      programs.fzf = {
        enable = true;
        colors = {
          bg = "${clr.base00}";
          "bg+" = "${clr.base01}";
          fg = "${clr.base04}";
          "fg+" = "${clr.base06}";

          header = "${clr.base0D}";
          hl = "${clr.base0D}";
          "hl+" = "${clr.base0D}";

          info = "${clr.base0A}";
          marker = "${clr.base0C}";
          pointer = "${clr.base0C}";

          prompt = "${clr.base0A}";
          spinner = "${clr.base0C}";
        };
      };
    };
}
