{ self, inputs, ... }:
{
  flake.modules.nixos.zoxide =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [ zoxide ];

      programs.bash.interactiveShellInit = /* bash */ ''eval "$(zoxide init --cmd cd bash)"'';
    };
}
