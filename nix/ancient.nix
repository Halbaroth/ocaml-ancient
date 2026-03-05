{
  buildDunePackage,
  lib,
}:

buildDunePackage {
  pname = "ancient";
  version = "dev";
  src = ../.;

  meta = {
    description = "Ancient library";
    homepage = "https://github.com/OCamlPro/ocaml-ancient";
    license = lib.licenses.gpl2;
  };
}
