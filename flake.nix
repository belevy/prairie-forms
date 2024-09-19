{
  description = "prairie-forms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = input@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem ( system:
      let
        pkgs = import nixpkgs {
                    inherit system;
                    config = { allowUnfree = true; };
                    overlays = [(_final : _prev : {
                    })];
                };

        haskellPackages = pkgs.haskellPackages;

        packageName = "prarie-forms";

    in {

        packages.${packageName} =
          haskellPackages.developPackage {
            root = ./. ;
            withHoogle = false;
            source-overrides = {
            };
            overrides = final: prev: {
            };
          };

        packages.default = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
            inputsFrom = [
                self.packages.${system}.default.env
            ];

            # Development packages
            buildInputs = [
              # Haskell
              pkgs.cabal-install
              pkgs.ghcid
              pkgs.haskellPackages.haskell-language-server
              pkgs.haskellPackages.stylish-haskell

              # General
              pkgs.gnumake
            ];

          };
      });
}
