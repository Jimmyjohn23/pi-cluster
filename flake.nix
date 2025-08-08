
{
  description = "Flake for Raspberry Pi cluster - federated learning + CV + Docker & K8s";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pythonEnv = pkgs.python311.withPackages (ps: with ps; [
          pip virtualenv numpy scipy pandas scikit-learn pytorch torchvision
        ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zellij git curl docker kubectl
            pythonEnv
            cmake gcc pkg-config
          ];

          shellHook = ''
            echo "Welcome to the Raspberry Pi cluster dev shell!"
            export PYTHONPATH=$PYTHONPATH:${pythonEnv.sitePackages}
          '';
        };
      });
}