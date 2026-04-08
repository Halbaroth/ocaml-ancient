{
  description = "Ancient library";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt;

        packages.default = pkgs.ocamlPackages.callPackage ./nix/ancient.nix { };

        overlays.default = super: self: {
          ocamlPackages = self.ocamlPackages.overrideScope (
            final: prev: {
              ocamlPackages.ancient = final.callPackage ./nix/ancient.nix { };
            }
          );
        };

        devShells.default = pkgs.callPackage ./nix/devshell.nix {
          enableDebug = true;
        };
      }
    );
}
