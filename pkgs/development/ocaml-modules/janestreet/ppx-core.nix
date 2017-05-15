{stdenv, buildOcamlJane, jbuilder
, ocaml-compiler-libs, ppx_ast, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_core";
  hash = "1dqznn1a4x1g8r0mrwcvk67dhyslqd00x64ks42mmx9y99kqshj7";
  buildInputs = [ jbuilder ppx_ast ];
  propagatedBuildInputs =
    [ ocaml-compiler-libs ppx_tools ];
  inherit (jbuilder) installPhase;
  noConfigure = true;

  meta = with stdenv.lib; {
    description = "PPX standard library";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
