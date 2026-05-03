{ inputs, ... }:
{
  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    services.openssh.generateHostKeys = true;
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      age = {
        # Automatically import host SSH keys as age keys
        sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
        # Uses an age key already present in the filesystem
        keyFile = "/persist/var/lib/sops-nix/key.txt";
        # Otherwise generate a new key
        generateKey = true;
      };
    };

    custom.impermanence.root.directories = [ "/var/lib/sops-nix" ];
  };
}
