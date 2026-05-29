{
  lib,
  buildDunePackage,
}:

buildDunePackage {
  pname = "ancient";
  version = "dev";
  src = lib.cleanSource ../.;

  doCheck = true;

  meta = {
    description = "Ancient library";
    homepage = "https://github.com/OCamlPro/ocaml-ancient";
    license = lib.licenses.lgpl21Plus;
  };
}
