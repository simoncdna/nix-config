{ config, inputs, pkgs, ... }:
{
	imports = [
		inputs.ags.homeManagerModules.default
	];

	programs.ags = {
		enable = true;

		# Packages supplémentaires pour les widgets
		extraPackages = with inputs.ags.packages.${pkgs.system}; [
			hyprland
			battery
			network
			tray
			wireplumber
		];
	};

	xdg.configFile."ags".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/files/ags";
}
