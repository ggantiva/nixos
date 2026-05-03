{ self, inputs, ... }:
{
  flake.modules.nixos.ssh = {
    hj.files.".ssh/config".text = ''
      AddKeysToAgent yes
      IdentitiesOnly yes
      CheckHostIp yes
      HashKnownHosts yes
      IdentityAgent none
    '';
  };
}
