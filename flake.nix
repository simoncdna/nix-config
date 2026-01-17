{
	description = "Simon's Nix system configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		ags = {
			url = "github:aylur/ags";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = 
		{ ... }@inputs: {
			nixosConfigurations = {
				nixos-mac = inputs.nixpkgs.lib.nixosSystem {
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
