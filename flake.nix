{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = 
    { 
      self, 
      nixpkgs, 
      home-manager, 
      ... 
    }@inputs: 
    let # Read some documentation about how hacky this is ><
      inherit (self) outputs;
    in {
      nixosConfigurations = {
        lilly = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs };
          modules = [ ./nixos/lilly/configuration.nix ];
        }
        matthijs = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs };
          modules = [ ./nixos/matthijs/configuration.nix ];
        }

        homeConfigurations = {
          "main@lilly" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs; }
            modules [ ./home/lilly/default.nix ]
          };
          
          "main@matthijs" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs; }
            modules [ ./home/matthijs/default.nix ]
          };
        }
      };
    };
  };
}
