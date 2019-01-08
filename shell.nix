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
  lib             = pkgs.haskell.lib;
  haskOverrides = {
    overrides = hsNew: hsOld: rec {
      cereal          = lib.dontCheck hsOld.cereal;
      aeson           = lib.dontCheck (hsNew.callPackage ./nix/aeson.nix {});
      zeromq4-haskell = lib.dontCheck hsOld.zeromq4-haskell;
      ipython-kernel  = hsNew.callPackage ./nix/ipython-kernel.nix {};
      ihaskell        = lib.dontCheck (hsNew.callPackage ./nix/ihaskell.nix {});
    };
  };
  haskellPackages = pkgs.haskell.packages.ghc844.override haskOverrides;
  haskp           = haskellPackages.ghcWithPackages (hp: with hp;
    [ ihaskell
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
      export PYTHONPATH=$PWD
      export XDG_DATA_HOME=$PWD/.XDG
      export JUPYTER_CONFIG_DIR=$PWD/.XDG/jupyter
      '';
  }
