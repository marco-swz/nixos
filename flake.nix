{
    description = "Nix flake for managing system states";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgsUnstable, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        pkgsUnstable = import nixpkgsUnstable {
            inherit system;
        };
    in {
        nixosConfigurations = {
            notebook = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs pkgsUnstable; };
                modules = [ 
                    ./global.nix 
                    ./notebook/configuration.nix 
                ];
            };
            desktop = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs pkgsUnstable; };
                modules = [ 
                    ./global.nix 
                    ./desktop/configuration.nix 
                ];
            };
            desktop2 = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs pkgsUnstable; };
                modules = [
                    ./global.nix
                    ./desktop2/configuration.nix
                ];
            };
            desktop-old = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs system pkgs; };
                modules = [ 
                    ./global.nix 
                    ./desktop-old/configuration.nix 
                ];
            };
        };
    };
}
