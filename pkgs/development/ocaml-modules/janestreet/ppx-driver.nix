{stdenv, buildOcamlJane, jbuilder
, ocaml-migrate-parsetree
, ppx_core, ppx_optcomp}:

buildOcamlJane rec {
  name = "ppx_driver";
  hash = "0wg14ww35s0p7yli57zm5kin40fy6anbggkdirab67sl2d4z6jrm";
  buildInputs = [ jbuilder ocaml-migrate-parsetree ];
  propagatedBuildInputs =
    [ ppx_core ppx_optcomp ];
  noConfigure = true;

  meta = with stdenv.lib; {
    description = "A driver is an executable created from a set of OCaml AST transformers linked together with a command line frontend";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
