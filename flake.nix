{
    description = "Nix flake for managing system states";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };

    in {
        nixosConfigurations = {
            notebook = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs; };
                modules = [ 
                    ./nixos/notebook/configuration.nix 
                ];
            };
            desktop = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs; };
                modules = [ 
                    ./nixos/desktop/configuration.nix 
                ];
            };
            desktop-old = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs; };
                modules = [ 
                    ./nixos/desktop-old/configuration.nix 
                ];
            };
        };
    };
}
