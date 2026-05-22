{
  flake.modules.homeManager.kitty = {
    home.file.".config/kitty/sessions/home.kitty-session".text = ''
      layout splits
      cd ~

      launch --title "Home"
    '';
  };
}
