{ ... }:
{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		oh-my-zsh = {
			enable = true;
			theme = "robbyrussell";
			plugins = [ "git" "sudo" "history" "fzf" "web-search" ];
		};

		shellAliases = {
			vim = "nvim";
		};

		initContent = ''
			export EDITOR=nvim
			export PATH="$HOME/.local/bin:$PATH"
			'';
	};
}
