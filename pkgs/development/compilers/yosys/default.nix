{ stdenv, fetchFromGitHub
, pkgconfig, bison, flex
, tcl, readline, libffi, python3
, protobuf, zlib
, verilog
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "yosys";
  version = "2019.09.27";

  srcs = [
    (fetchFromGitHub {
      owner  = "yosyshq";
      repo   = "yosys";
      rev    = "c372e7baf9c48d41ebdbea4486a72e8dfaaddd3d";
      sha256 = "18cyz900haf8lkpddqn0sns0a3hc8fqndzz7gg391671hzvy820k";
      name   = "yosys";
    })

    # NOTE: the version of abc used here is synchronized with
    # the one in the yosys Makefile of the version above;
    # keep them the same for quality purposes.
    (fetchFromGitHub {
      owner  = "berkeley-abc";
      repo   = "abc";
      rev    = "5776ad07e7247993976bffed4802a5737c456782";
      sha256 = "1la4idmssg44rp6hd63sd5vybvs3vr14yzvwcg03ls37p39cslnl";
      name   = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ tcl readline libffi python3 bison flex protobuf zlib ];

  makeFlags = [ "ENABLE_PROTOBUF=1" ];

  patchPhase = ''
    substituteInPlace ../yosys-abc/Makefile \
      --replace 'CC   := gcc' "" \
      --replace 'CXX  := g++' ""
    substituteInPlace ./Makefile \
      --replace 'CXX = clang' "" \
      --replace 'LD = clang++' 'LD = $(CXX)' \
      --replace 'CXX = gcc' "" \
      --replace 'LD = gcc' 'LD = $(CXX)' \
      --replace 'ABCMKARGS = CC="$(CXX)" CXX="$(CXX)"' 'ABCMKARGS =' \
      --replace 'echo UNKNOWN' 'echo ${substring 0 10 (elemAt srcs 0).rev}'
    patchShebangs tests
  '';

  preBuild = ''
    chmod -R u+w ../yosys-abc
    ln -s ../yosys-abc abc
    make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}
    echo 'ABCREV := default' >> Makefile.conf
    makeFlags="PREFIX=$out $makeFlags"

    # we have to do this ourselves for some reason...
    (cd misc && ${protobuf}/bin/protoc --cpp_out ../backends/protobuf/ ./yosys.proto)
  '';

  doCheck = true;
  checkInputs = [ verilog ];
  # checkPhase defaults to VERBOSE=y, which gets passed down to abc,
  # which then does $(VERBOSE)gcc, which then complains about not
  # being able to find ygcc. Life is pain.
  checkFlags = [ " " ];

  meta = {
    description = "Framework for RTL synthesis tools";
    longDescription = ''
      Yosys is a framework for RTL synthesis tools. It currently has
      extensive Verilog-2005 support and provides a basic set of
      synthesis algorithms for various application domains.
      Yosys can be adapted to perform any synthesis job by combining
      the existing passes (algorithms) using synthesis scripts and
      adding additional passes as needed by extending the yosys C++
      code base.
    '';
    homepage    = http://www.clifford.at/yosys/;
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
