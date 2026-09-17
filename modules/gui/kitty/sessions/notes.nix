{
  flake.modules.homeManager.kitty = {
    home.file.".config/kitty/sessions/notes.kitty-session".text = ''
      layout tall
      cd ~/Notes/

      launch --title "Notes" nvim .
    '';
  };
}
