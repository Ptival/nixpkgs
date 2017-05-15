{ buildOcaml, opam, js_build_tools, ocaml_oasis_46, fetchurl } :

{ name, version ? "v0.9", buildInputs ? [],
  hash ? "",
  noConfigure ? false,
  minimumSupportedOcamlVersion ? "4.03", ...
}@args:

buildOcaml (args // {
  inherit name version minimumSupportedOcamlVersion;
  src = fetchurl {
    url = "https://github.com/janestreet/${name}/archive/${version}.tar.gz";
    sha256 = hash;
  };

  hasSharedObjects = true;

  buildInputs = [ ocaml_oasis_46 js_build_tools opam ] ++ buildInputs;

  dontAddPrefix = true;

  configurePhase =
    if noConfigure then "" else "./configure --prefix $out";

  buildPhase = "OCAML_TOPLEVEL_PATH=`ocamlfind query findlib`/.. make";

  installPhase = ''
    opam-installer -i --prefix $prefix --libdir `ocamlfind printconf destdir` --stubsdir `ocamlfind printconf destdir`/${name} ${name}.install
    if [ -d $out/lib/${name} ]
      then if [ "$(ls -A $out/lib/${name})" ]
        then mv $out/lib/${name}/* `ocamlfind printconf destdir`/${name}
      fi
      rmdir $out/lib/${name}
    fi
  '';

})
