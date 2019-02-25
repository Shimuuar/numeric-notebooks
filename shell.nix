let
  pkgs   = import <nixpkgs> {inherit config;};
  config = {
    packageOverrides = pkgs: {
#      ihask = pkgs.callPackage ./nix/ihaskell-kernel.nix {};
      haskell = pkgs.haskell // {
        packageOverrides = haskOverrides;        
      };
    };
  };
  # Python packages
  python = pkgs.python3;
  pyp = python.withPackages (ps: with ps;
    [ jupyter_core
      jupyter_client
      notebook
    ]);
  # Haskell packages
  lib           = pkgs.haskell.lib;
  haskOverrides = hsNew: hsOld: rec {
    cereal          = lib.dontCheck hsOld.cereal;
    aeson           = lib.dontCheck (hsNew.callPackage ./nix/aeson.nix {});
    zeromq4-haskell = lib.dontCheck hsOld.zeromq4-haskell;
    ipython-kernel  = hsNew.callPackage ./nix/ipython-kernel.nix {};
    ihaskell        = lib.dontCheck (hsNew.callPackage ./nix/ihaskell.nix {});
    ghc-parser      = hsNew.callPackage ./nix/ghc-parser.nix {};
  };
  #
  haskp = pkgs.haskellPackages.ghcWithPackages (hp: with hp;
    [ math-functions
      primitive
      base58-bytestring
#      ihaskell
#      #
#      math-functions
#      primitive
    ]);

#  ihaskellKernel = stdenv.mkDerivation {
#    name = "ihaskell-kernel";
#    phases = "installPhase";
#    src = ./haskell.svg;
#    buildInputs = [ ihaskellEnv ];
#    installPhase = ''
#      mkdir -p $out/kernels/ihaskell_${name}
#      cp $src $out/kernels/ihaskell_${name}/logo-64x64.svg
#      echo '${builtins.toJSON kernelFile}' > $out/kernels/ihaskell_${name}/kernel.json
#    '';
#  };
  
in
  pkgs.stdenv.mkDerivation {
    name        = "shell";
    buildInputs = [ pyp
                    haskp
                    pkgs.haskellPackages.ihaskell
#(pkgs.callPackage ./nix/ihaskell-kernel.nix
#    {packages = hp: with hp; [primitive base58-bytestring];}
#    )
                  ];
    #
    shellHook =
      ''
      export GHC_PACKAGE_PATH=$(echo ${haskp}/lib/*/package.conf.d| tr ' ' ':')
      export PATH=$(echo ${haskp}/bin):$PATH
      export XDG_DATA_HOME=$PWD/.XDG
      export JUPYTER_CONFIG_DIR=$PWD/.XDG/jupyter
      '';
  }
