{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nix = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/nix/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = {
              imports = [ ./home.nix ];
            };
          }
        ];
      };

      nixos = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/nixos/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = {
              imports = [ ./home.nix ];
            };
          }
        ];
      };
    };
  };
}
