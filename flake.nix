{
    description = "Nix flake for managing system states";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs2205.url = "github:nixos/nixpkgs/nixos-22.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs2205, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
                "electron-25.9.0"
            ];
        };

        pkgs2205 = import nixpkgs2205 {
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
                specialArgs = { inherit inputs system pkgs pkgs2205; };
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
