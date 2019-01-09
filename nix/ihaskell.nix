{ mkDerivation, fetchgit, aeson, base, base64-bytestring, bytestring, cereal
, cmdargs, containers, directory, filepath, ghc, ghc-boot
, ghc-parser, ghc-paths, haskeline, haskell-src-exts, here, hlint
, hspec, hspec-contrib, http-client, http-client-tls, HUnit
, ipython-kernel, mtl, parsec, process, random, setenv, shelly
, split, stdenv, stm, strict, system-argv0, text, transformers
, unix, unordered-containers, utf8-string, uuid, vector, raw-strings-qq
}:
mkDerivation {
  pname = "ihaskell";
  version = "0.9.1.0";
  src = fetchgit {
    url    = "https://github.com/gibiansky/IHaskell";
    sha256 = "06swyapw8if1rgxpx06vf8r7yj5vb8mpgd9jwkf87zzlq5c2h6hb";
    rev    = "13632726fe004db0e2869b8666a48da1be79d5f6";
    # sha256 = "05vjzrvhjzd6z30r74nvw316h8xd6m35assy097bzly60j8xw4fc";
    # rev    = "ab98e1b1442b23aba6c7d62b05db930f033dd522";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base base64-bytestring bytestring cereal cmdargs containers
    directory filepath ghc ghc-boot ghc-parser ghc-paths haskeline
    haskell-src-exts hlint http-client http-client-tls ipython-kernel
    mtl parsec process random shelly split stm strict system-argv0 text
    transformers unix unordered-containers utf8-string uuid vector raw-strings-qq
  ];
  executableHaskellDepends = [
    aeson base bytestring containers directory ghc ipython-kernel
    process strict text transformers unix
  ];
  testHaskellDepends = [
    base directory ghc ghc-paths here hspec hspec-contrib HUnit setenv
    shelly text transformers
  ];
  homepage = "http://github.com/gibiansky/IHaskell";
  description = "A Haskell backend kernel for the IPython project";
  license = stdenv.lib.licenses.mit;
}
