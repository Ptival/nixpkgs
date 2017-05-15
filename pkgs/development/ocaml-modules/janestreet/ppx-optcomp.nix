{stdenv, buildOcamlJane, jbuilder,
 ppx_core, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_optcomp";
  hash = "0348csh5kbd6mizwpgyb6my2i62v74xqhqarn2krxalkaj5n2kmj";
  buildInputs = [ jbuilder ];
  propagatedBuildInputs =
    [ ppx_core ppx_tools ];

  meta = with stdenv.lib; {
    description = "ppx_optcomp stands for Optional Compilation. It is a tool used to handle optional compilations of pieces of code depending of the word size, the version of the compiler, etc.";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
