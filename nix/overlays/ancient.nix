self: super:
let
  mkOverride =
    ocamlPackages:
    ocamlPackages.overrideScope (
      final: prev: {
        ancient = final.callPackage ./ancient.nix { };
      }
    );
in
{
  ocamlPackages = mkOverride super.ocamlPackages;

  ocaml-ng = super.ocaml-ng // {
    ocamlPackages_4_14 = mkOverride super.ocaml-ng.ocamlPackages_4_14;
    ocamlPackages_5_0 = mkOverride super.ocaml-ng.ocamlPackages_5_0;
    ocamlPackages_5_1 = mkOverride super.ocaml-ng.ocamlPackages_5_1;
    ocamlPackages_5_2 = mkOverride super.ocaml-ng.ocamlPackages_5_2;
    ocamlPackages_5_3 = mkOverride super.ocaml-ng.ocamlPackages_5_3;
    ocamlPackages_5_4 = mkOverride super.ocaml-ng.ocamlPackages_5_4;
  };
}
