{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustc
            rustfmt
            cargo
            rust-analyzer
            (python314.withPackages (python-pkgs:
              with python-pkgs; [
                pandas
                numpy
              ]))
            (rWrapper.override {
              packages = with rPackages; [irace];
            })
            (writeShellScriptBin "irace" ''
              exec Rscript -e "library(irace); irace_cmdline('$@')"
            '')
          ];
        };
      }
    );
}
