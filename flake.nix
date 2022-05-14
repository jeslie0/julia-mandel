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
          packages.c-julia = pkgs.stdenv.mkDerivation {
            pname = "c-julia";
            version = "0.0.1";
            src = ./src;
            buildInputs = [pkgs.libpng];
            buildPhase = "gcc julia.c -o julia -lm";
            installPhase = ''
                         mkdir -p $out/bin
                         cp julia $out/bin
                         '';
          };

          defaultPackage = self.packages.${system}.c-julia;

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.c-julia
                         ];
            buildInputs = with pkgs;
              [ clang-tools
              ];
          };
        }
    );
}
