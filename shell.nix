let
  pkgs   = import <nixpkgs> {inherit config;};
  config = {};
  # Python packages
  python = pkgs.python3;
  pyp = python.withPackages (ps: with ps;
    [ jupyter_core
      jupyter_client
      notebook
    ]);
  # Haskell packages
  lib           = pkgs.haskell.lib;
  haskOverrides = {
    overrides = hsNew: hsOld: rec {
      cereal          = lib.dontCheck hsOld.cereal;
      aeson           = lib.dontCheck (hsNew.callPackage ./nix/aeson.nix {});
      zeromq4-haskell = lib.dontCheck hsOld.zeromq4-haskell;
      ipython-kernel  = hsNew.callPackage ./nix/ipython-kernel.nix {};
      ihaskell        = lib.dontCheck (hsNew.callPackage ./nix/ihaskell.nix {});
      ghc-parser      = hsNew.callPackage ./nix/ghc-parser.nix {};
    };
  };
  haskellPackages = pkgs.haskell.packages.ghc863.override haskOverrides;
  haskp           = haskellPackages.ghcWithPackages (hp: with hp;
    [ ipython-kernel
      ihaskell
      #
      math-functions
      primitive
    ]);
in
  pkgs.stdenv.mkDerivation {
    name        = "shell";
    buildInputs = [ pyp
                    haskp
                  ];
    #
    shellHook =
      ''
      export GHC_PACKAGE_PATH=$(echo ${haskp}/lib/*/package.conf.d| tr ' ' ':')
      export XDG_DATA_HOME=$PWD/.XDG
      export JUPYTER_CONFIG_DIR=$PWD/.XDG/jupyter
      '';
  }
