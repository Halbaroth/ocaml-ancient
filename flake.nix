{
  description = "The Ancient library";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ocaml-debug-info-overlay.url = "path:/home/tiky/projects/ocaml-debug-info-overlay";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          _module.args.pkgs = import self.inputs.nixpkgs {
            inherit system;
            overlays = [ (import ./nix/overlays/ocaml-nnp.nix) ];
          };

          formatter = pkgs.nixfmt-tree;

          packages.default = pkgs.ocamlPackages.callPackage ./nix/ancient.nix { };

          devShells =
            let
              mkShell =
                {
                  version ? "5_3",
                  debug ? false,
                }:
                let
                  devPkgs =
                    let
                      debug-overlay = inputs.ocaml-debug-info-overlay.overlays.default;
                    in
                    if debug then pkgs.extend debug-overlay else pkgs;
                  ocamlPackages = devPkgs.ocaml-ng."ocamlPackages_${version}";
                in
                devPkgs.mkShell {
                  packages = with ocamlPackages; [
                    odoc
                    ocaml-lsp
                    dune-release
                    ocamlformat
                  ];

                  inputsFrom = [ (ocamlPackages.callPackage ./nix/ancient.nix { }) ];
                };
            in
            {
              default = mkShell { };
              ocaml4 = mkShell { version = "4_14"; };
              debug = mkShell { debug = true; };
            };
        };

      flake.overlays = {
        default = inputs.nixpkgs.lib.fixedPoints.composeManyExtensions [
          (import ./nix/overlays/ocaml-nnp.nix)
          (import ./nix/overlays/ancient.nix)
        ];
      };
    };
}
