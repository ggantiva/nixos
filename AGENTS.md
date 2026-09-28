# Overview

NixOS and Home Manager configurations using flakes, applying the dendritic pattern powered by flake-parts and import-tree.

## Architecture and Structure

All `.nix` files under `modules/` are auto-imported via `import-tree`:

- `modules/cli`: CLI tools & shell configuration.
- `modules/gui`: Desktop environment & GUI apps.
- `modules/hosts`: Host definitions.
- `modules/nix`: Core Nix setup (`flake-parts`, `home-manager`, `sops`,
  `impermanence`, `constants`).
- `modules/services`: System services.
- `modules/system`: Core OS modules and system types.
- `modules/users`: User definitions.

## Module Conventions

- Reference shared constants defined in `modules/nix/constants.nix`
- Secret management uses `sops-nix`
