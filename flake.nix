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
            pname = "juliac";
            version = "0.0.1";
            src = ./src;
            buildInputs = [ pkgs.libpng ];
            buildPhase = "gcc julia.c -o juliac -lm";
            installPhase = ''
                         mkdir -p $out/bin
                         cp julia $out/bin
                         '';
          };

          packages.juliamandelpy = pkgs.stdenv.mkDerivation {
            pname = "juliapy";
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




          defaultPackage = self.packages.${system}.c-julia;

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.c-julia
                           self.packages.${system}.juliamandelpy
                           self.packages.${system}.tweet
                         ];
            buildInputs = with pkgs;
              [ clang-tools
              ];
          };
        }
    );
}
