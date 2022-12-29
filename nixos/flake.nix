{
    description = "Pumita's configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        lib = import ./lib { inherit nixpkgs home-manager pkgs system; };
    in {
        nixosConfigurations = lib.mkMachines {
            ctftime = {};
        };

        homeConfigurations = lib.mkHomes {
            player = {};
        };
    };
}