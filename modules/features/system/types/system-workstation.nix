{ self, inputs, ... }:
{
  flake.modules.nixos.system-workstation = {
    imports = with self.modules.nixos; [
      system-base

      niri
      foot

      librewolf
    ];
  };
}
