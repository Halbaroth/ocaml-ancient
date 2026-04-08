{
  lib,
  ocamlPackages,
  stdenv,
  mkShell,
  enableDebug ? false,
  ...
}:
let
  o = ocamlPackages.overrideScope (
    final: prev: {
      ocaml-src = stdenv.mkDerivation {
        pname = "ocaml-src";
        inherit (prev.ocaml) src version patches;
        phases = [
          "unpackPhase"
          "patchPhase"
          "installPhase"
        ];
        installPhase = ''
          cp -r . $out
        '';
      };

      ocaml =
        (prev.ocaml.overrideAttrs (old: {
          dontStrip = enableDebug;
          separateDebugInfo = enableDebug;
          dontCheckForBrokenSymlinks = enableDebug;

          configureFlags =
            (old.configureFlags or [ ])
            ++ (lib.optional enableDebug "CFLAGS=-fdebug-prefix-map=/build/ocaml-${final.ocaml.version}=${final.ocaml-src}");
        })).override
          ({
            framePointerSupport = enableDebug;
            noNakedPointers = prev.ocaml.version == "4.14";
          });
    }
  );
in
mkShell {
  packages =
    with o;
    (
      [
        utop
        odoc
        ocaml-lsp
        patdiff
        dune-release
        ocamlformat
      ]
      ++ (lib.optional (ocaml ? debug) ocaml.debug)
    );

  inputsFrom = [
    (o.callPackage ./ancient.nix { })
  ];
}
