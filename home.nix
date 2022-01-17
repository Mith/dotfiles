{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  accounts.email.accounts = {
    gmail = {
      address = "simonvoordouw@gmail.com";
      flavor = "gmail.com";
      primary = true;
    };
  };

  home.packages = with pkgs; [
    discord
    godot
    fd
    ripgrep
    transmission-gtk
    tldr
    gimp
    gnome-mpv
    bitwarden-cli
    vlc
    teams
    libreoffice
    cntr
    navi
    lutris
    calibre
    vulkan-loader
    vulkan-tools
    # renderdoc
    obs-studio
    blender
    neovide
    protontricks
    p7zip
    gnome.zenity
    bash
    curl
    helix
    (python3Packages.python-lsp-server.override (old: {
      withRope = true;
      withFlake8 = true;
    }))
    python3Packages.python-lsp-black
    python3Packages.pylsp-mypy
    rust-analyzer
  ];

  xdg.enable = true;

  programs.firefox.enable = true;
  programs.chromium.enable = true;

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
      vim-polyglot
      sleuth
      comment-nvim
      vista-vim
      vim-repeat
      vim-surround
      vim-vinegar
      rust-vim
      telescope-nvim
      telescope-fzf-native-nvim
      sqlite-lua
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-rust
          tree-sitter-python
          tree-sitter-lua
          tree-sitter-vim
          tree-sitter-comment
          tree-sitter-markdown
          tree-sitter-bash
          tree-sitter-html
          tree-sitter-cpp
          tree-sitter-haskell
        ]
      ))
      nvim-treesitter-textobjects
      nvim-treesitter-refactor
      nvim-dap
      nvim-dap-virtual-text
      plenary-nvim
      popup-nvim
      nvim-lspconfig
      nvim-cmp
      cmp_luasnip
      luasnip
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-buffer
      cmp-cmdline
      nvim-web-devicons
      auto-session
      neogit
      nvcode-color-schemes-vim
      rust-tools-nvim
      which-key-nvim
      lightspeed-nvim
      # copilot-vim
      nvim-autopairs
      direnv-vim
      lualine-nvim
      vim-matchup
    ];

    extraPackages = with pkgs; [
      universal-ctags
      rust-analyzer
      clang-tools
      rnix-lsp
      nodePackages.pyright
      nodePackages.bash-language-server
      nodePackages.vim-language-server
      cmake-language-server
      nixpkgs-fmt
      sumneko-lua-language-server
      tree-sitter
      omnisharp-roslyn
      xclip
      luaformatter
      lldb
    ];

    extraConfig = "lua require('init')";
  };
  xdg.configFile."nvim/lua".source = nvim/lua;

  xdg.configFile."helix/config.toml".text = ''
    theme = "bogster"
  '';

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
    '';
    functions = {
      bwu = "set -xU BW_SESSION (bw unlock --raw $argv[1])";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
