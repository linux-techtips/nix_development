{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    devenv.url = "github:cachix/devenv";
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, devenv, pyproject-nix, ... }@inputs:
    let
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python312;

    in {
      packages.${system}.devenv-up = self.devShells.${system}.default.config.procfileScript;

      devShells.${system}.default = 
        let
          arg = project.renderers.withPackages { inherit python; };
          pythonEnv = python.withPackages arg;

        in devenv.lib.mkShell {
          inherit inputs pkgs;

          modules = [
            ({ pkgs, config, ... }: {
              packages = [ pythonEnv ];

              processes.run.exec = "python package";

              scripts.dev.exec = ''
                uvicorn package.__main__:app --reload
              '';
          })
        ];
      };
    };
}
