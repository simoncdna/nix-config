{ ... }:
{
	programs.git = {
		enable = true;

		settings = {
			user.name = "Simon Cardona";
			user.email = "simon.cdna@proton.me";
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
