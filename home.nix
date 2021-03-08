{ pkgs, ... }:
{
	home.packages = with pkgs; [
		discord
		any-nix-shell
		fd
		ripgrep
		transmission-gtk
		tldr
		gimp
		universal-ctags
		signal-desktop
		pulseeffects-pw
		kitty
	];

	programs.firefox = {
		enable = true;
		enableGnomeExtensions = true;
	};

	programs.neovim = {
		enable = true;
		withNodeJs = true;
		package = pkgs.neovim-nightly;
		plugins = with pkgs.vimPlugins; [ 
			polyglot 
			sleuth 
			base16-vim 
			vim-commentary
			vim-clap
			vista-vim
			vim-repeat
			vim-surround
			vim-vinegar
			rust-vim
			telescope-nvim
			telescope-fzy-native-nvim
			nvim-treesitter
			nvim-treesitter-textobjects
			nvim-dap
			nvim-dap-virtual-text
			plenary-nvim
			popup-nvim
			nvim-lspconfig
			completion-nvim
		];

		extraConfig = builtins.readFile ./nvim/init.vim;
	};

	xdg.configFile."nvim/lua".source = nvim/lua;

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
