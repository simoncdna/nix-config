{
	description = "Simon's Nix system configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = 
		{ ... }@inputs: {
			nixosConfigurations = {
				nixos = inputs.nixpkgs.lib.nixosSystem {
					system = "aarch64-linux";
					specialArgs = { inherit inputs; };
					modules = [
						./hosts/nixos-mac/configuration.nix

						inputs.home-manager.nixosModules.home-manager

						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.users.simon = import ./home/profiles/default.nix;
							home-manager.extraSpecialArgs = { inherit inputs; };
						}
					];
				};
			};
	};
}
