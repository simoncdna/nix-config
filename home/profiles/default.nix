{ ... }:
{

	# Basic informations
	home.username = "simon";
	home.homeDirectory = "/home/simon";
	home.stateVersion = "25.11";

	# Modules
	imports = [];

	# Files
	home.file.".config/nvim".source = ../files/nvim;

	# Activate the home-manager cmd
	programs.home-manager.enable = true;
}
