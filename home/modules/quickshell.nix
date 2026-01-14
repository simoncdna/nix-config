{ pkgs, ... }:
{
	home.packages = with pkgs; [
		quickshell
	];

	xdg.configFile."quickshell" = {
		source = ../files/quickshell;
		recursive = true;
	};
}
