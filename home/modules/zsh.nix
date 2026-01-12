{ ... }:
{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			vim = "nvim";
		};

		initExtra = ''
			export EDITOR=nvim
			export PATH="$HOME/.local/bin:$PATH"
			'';
	};
}
