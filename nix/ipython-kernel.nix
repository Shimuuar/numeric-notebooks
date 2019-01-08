{ mkDerivation, fetchgit, aeson, base, bytestring, cereal, cereal-text
, containers, cryptonite, directory, filepath, memory, mtl, process
, stdenv, temporary, text, transformers, unordered-containers, uuid
, zeromq4-haskell
}:
mkDerivation {
  pname = "ipython-kernel";
  version = "0.10.0.0";
  src = fetchgit {
    url    = "https://github.com/gibiansky/IHaskell";
    sha256 = "05vjzrvhjzd6z30r74nvw316h8xd6m35assy097bzly60j8xw4fc";
    rev    = "ab98e1b1442b23aba6c7d62b05db930f033dd522";
  };
  postUnpack = "sourceRoot+=/ipython-kernel; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = false;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring cereal cereal-text containers cryptonite directory
    filepath memory mtl process temporary text transformers
    unordered-containers uuid zeromq4-haskell
  ];
  homepage = "http://github.com/gibiansky/IHaskell";
  description = "A library for creating kernels for IPython frontends";
  license = stdenv.lib.licenses.mit;
}
