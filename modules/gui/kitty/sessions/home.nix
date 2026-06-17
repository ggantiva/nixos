{
  flake.modules.homeManager.kitty = {
    home.file.".config/kitty/sessions/home.kitty-session".text = ''
      layout tall
      cd ~

      launch --title "Home"
    '';
  };
}
