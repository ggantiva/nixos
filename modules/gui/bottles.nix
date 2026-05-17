{
  flake.modules.nixos.bottles = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.bottles.override {
        removeWarningPopup = true;

        # Openldap fix see https://github.com/NixOS/nixpkgs/issues/513245
        # Intercept buildFHSEnv to modify target packages
        buildFHSEnv = args:
          pkgs.buildFHSEnv (
            args
            // {
              multiPkgs = envPkgs: let
                # Fetch original package list
                originalPkgs = args.multiPkgs envPkgs;

                # Disable tests for openldap
                customLdap = envPkgs.openldap.overrideAttrs (_: {
                  doCheck = false;
                });
              in
                # Replace broken openldap with the custom one
                builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [customLdap];
            }
          );
      })
    ];
  };
}
