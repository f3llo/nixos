{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    in
    {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lilly = import ./home/default.nix;
	    home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }

        ];
      };
    };
  };
}
