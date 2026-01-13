{ ... }:
{
	programs.ghostty = {
		enable = true;

		settings = {
			theme = "rosepine";

			font-family = "JetBrainsMonoNL Nerd Font";
			font-size = 18;

			cursor-style = "block";
			cursor-style-blink = false;
			cursor-invert-fg-bg = true;

			confirm-close-surface = false;
			window-decoration = true;
			window-padding-x = 10;
			window-padding-y = 10;
			window-padding-balance = true;

			mouse-hide-while-typing = true;

			shell-integration-features = "no-cursor";

			copy-on-select = "clipboard";

			auto-update = "check";
			auto-update-channel = "stable";
		};
	};

	xdg.configFile."ghostty/themes".source = ../files/ghostty/themes;
}
