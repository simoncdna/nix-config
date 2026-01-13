{ ... }:
{
	programs.fastfetch = {
		enable = true;
	};

	xdg.configFile."fastfetch" = {
		source = ../files/fastfetch;
		recursive = true;
	};
}
