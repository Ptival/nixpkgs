{stdenv, buildOcamlJane,
 ppx_core, ppx_deriving, ppx_driver, ppx_tools}:

buildOcamlJane rec {
  name = "ppx_type_conv";
  hash = "1s657bhyakd9nfljgy74qkw2krczyf9cd74wjlkjwwfb9yy71nwi";
  propagatedBuildInputs =
    [ ppx_core ppx_deriving ppx_driver ppx_tools ];

  meta = with stdenv.lib; {
    description = "The type_conv library factors out functionality needed by different preprocessors that generate code from type specifications";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
