{stdenv, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv, sexplib}:

buildOcamlJane rec {
  name = "ppx_sexp_conv";
  hash = "1y47s8nw64sbyx1psfx1hfl4l9301l7nvm2i8yxrh5iwdffwaxh5";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv sexplib];

  meta = with stdenv.lib; {
    description = "PPX syntax extension that generates code for converting OCaml types to and from s-expressions, as defined in the sexplib library";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
