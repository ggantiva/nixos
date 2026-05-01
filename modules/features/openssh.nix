{ self, inputs, ... }:
{
  flake.modules.nixos.openssh = {
    enable = true;
    generateHostKeys = true;
    startWhenNeeded = true;
    ports = [ 2428 ];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
}
