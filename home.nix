{ pkgs, ... }:
{
	home.packages = with pkgs; [
		discord
		any-nix-shell
		fd
		ripgrep
		transmission-gtk
		tldr
		firefox
		gimp
		universal-ctags
		signal-desktop
		pulseeffects-pw
	];

	programs.neovim = {
		enable = true;
		withNodeJs = true;
		package = pkgs.neovim-nightly;
		plugins = with pkgs.vimPlugins; [ 
			coc-nvim 
			coc-rust-analyzer 
			polyglot 
			sleuth 
			base16-vim 
			vim-commentary
			vim-clap
			coc-clap
			vista-vim
			vim-repeat
			vim-surround
			vim-vinegar
			rust-vim
			telescope-nvim
			nvim-treesitter
			nvim-treesitter-textobjects
		];

		extraConfig = builtins.readFile ./init.vim;
	};

	programs.git = {
		enable = true;
		userEmail = "simonvoordouw@gmail.com";
		userName = "Simon Voordouw";
	};

	programs.fish = {
		enable = true;
		promptInit = ''
				any-nix-shell fish --info-right | source
		'';
	};

	programs.fzf = {
		enable = true;
		enableFishIntegration = true;
	};

	home.sessionVariables = {
		EDITOR = "nvim";
	};
}
