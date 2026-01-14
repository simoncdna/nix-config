{ ... }:
{

	# Basic informations
	home.username = "simon";
	home.homeDirectory = "/home/simon";
	home.stateVersion = "25.11";

	# Modules
	imports = [
		../modules/git.nix
		../modules/zsh.nix
		../modules/starship.nix
		../modules/ghostty.nix
		../modules/fastfetch.nix
		../modules/quickshell.nix
		../modules/sway.nix
	];

	# Files
	home.file.".config/nvim".source = ../files/nvim;

	# Activate the home-manager cmd
	programs.home-manager.enable = true;
}
