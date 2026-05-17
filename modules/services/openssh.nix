{
  flake.modules.nixos.openssh = {
    services.openssh = {
      enable = true;
      generateHostKeys = true;
      startWhenNeeded = true;
      ports = [2428];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        X11Forwarding = false;
      };
    };
  };
}
