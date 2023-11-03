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
      notebook = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/notebook/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = {
              imports = [ ./users/marco.nix ];
            };
          }
        ];
      };
      desktop = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/desktop/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = {
              imports = [ ./users/marco.nix ];
            };
          }
        ];
      };
      desktop-old = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/desktop-old/configuration.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = {
              imports = [ ./users/marco.nix ];
            };
          }
        ];
      };
    };
  };
}
