{ mkDerivation, fetchgit, base, cpphs, ghc, happy, stdenv }:
mkDerivation {
  pname = "ghc-parser";
  version = "0.2.0.2";
  src = fetchgit {
    url    = "https://github.com/gibiansky/IHaskell";
    sha256 = "06swyapw8if1rgxpx06vf8r7yj5vb8mpgd9jwkf87zzlq5c2h6hb";
    rev    = "13632726fe004db0e2869b8666a48da1be79d5f6";
    # sha256 = "05vjzrvhjzd6z30r74nvw316h8xd6m35assy097bzly60j8xw4fc";
    # rev    = "ab98e1b1442b23aba6c7d62b05db930f033dd522";
  };
  postUnpack = "sourceRoot+=/ghc-parser; echo source root reset to $sourceRoot";

  libraryHaskellDepends = [ base ghc ];
  libraryToolDepends = [ cpphs happy ];
  homepage = "https://github.com/gibiansky/IHaskell";
  description = "Haskell source parser from GHC";
  license = stdenv.lib.licenses.mit;
}
