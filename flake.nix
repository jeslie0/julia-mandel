{
  description = "C and Python code to build Julia and Mandelbrot sets.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dependencies = with pkgs; [  ]; # Input the build dependencies here
      in
        {
          packages.juliac = pkgs.stdenv.mkDerivation {
            name = "juliac";
            src = ./src;
            buildInputs = [ pkgs.libpng ];
            buildPhase = "gcc julia.c -o juliac -lm";
            installPhase = ''
                         mkdir -p $out/bin
                         cp juliac $out/bin
                         '';
          };

          packages.juliamandelpy = pkgs.stdenv.mkDerivation {
            pname = "juliamandelpy";
            version = "0.0.1";
            src = ./src;
            buildInputs = [ (pkgs.python39.buildEnv.override {
              extraLibs = with pkgs.python39Packages; [ ipython pillow ]; } ) ];

            buildPhase = "chmod +x juliamandel.py";
            installPhase = ''
                           mkdir -p $out/bin
                           cp juliamandel.py $out/bin/juliamandelpy
                           '';
        };


          packages.tweet = pkgs.stdenv.mkDerivation {
            name = "tweet";
            src = ./src;
            buildInputs = [ (self.packages.${system}.juliac) (pkgs.python39.buildEnv.override {
              extraLibs = with pkgs.python39Packages; [ ipython pillow tweepy ]; } ) ];
            buildPhase = ''
                         substituteInPlace ./tweet.py \
                         --replace '{0}/julia.out' '${self.packages.${system}.juliac}/bin/juliac'
                         chmod +x tweet.py
                         '';
            installPhase = ''
                           mkdir -p $out/bin
                           cp tweet.py $out/bin/tweet
                           '';
        };


          defaultPackage = self.packages.${system}.juliac;

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.juliac
                           # self.packages.${system}.juliamandelpy
                           self.packages.${system}.tweet
                         ];
            buildInputs = with pkgs;
              [ clang-tools
              ];
          };
        }
    );
}
