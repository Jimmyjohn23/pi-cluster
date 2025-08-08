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
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zellij git curl docker kubernetes-cli
            python311 python311Packages.pip python311Packages.virtualenv
            python311Packages.numpy python311Packages.scipy
            python311Packages.pandas python311Packages.scikit-learn
            python311Packages.pytorch python311Packages.torchvision
            cmake gcc pkg-config
          ];  # Note: k3s (the Kubernetes server) should be installed via apt on the master node
          shellHook = ''
            echo "🖥️  Welcome to Pi Cluster devShell (${system})"
            export PYTHONPATH=$PWD
          '';
        };
      }
    );
}