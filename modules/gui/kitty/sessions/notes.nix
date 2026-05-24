{
  flake.modules.homeManager.kitty = {
    home.file.".config/kitty/sessions/notes.kitty-session".text = ''
      layout splits
      cd ~/Notes/

      launch --title "Notes" vi .
    '';
  };
}
