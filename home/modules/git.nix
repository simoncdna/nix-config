{ ... }:
{
	programs.git = {
		enable = true;
		userName = "Simon Cardona";
		userEmail = "simon.cdna@proton.me";

		extraConfig = {
			init.defaultBranch = "main";
			pull.rebase = true;
		};

		ignores = [
			".DS_Store"
			"*.swp"
			".env"
			"*.local"
			".env.production"
			"/target"
			"/dist"
			"node_modules/"
			".vscode/"
			".idea"
		];
	};
}
