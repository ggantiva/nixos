# Installation

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#[System]

sudo nixos-install --flake .#[System] --no-root-passwd
```
