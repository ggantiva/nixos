{
  flake.modules.nixos.root = {
    users = {
      mutableUsers = false;
      users.root = {
        # Disable root user
        initialHashedPassword = "*";
      };
    };
  };
}
