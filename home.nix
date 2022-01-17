{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  accounts.email.accounts = {
    gmail = {
      address = "simonvoordouw@gmail.com";
      flavor = "gmail.com";
      primary = true;
    };
  #   rockstars = {
  #     address = "simon.voordouw@teamrockstars.nl";
  #   };
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
    rust-analyzer
  ];

  xdg.enable = true;

  # fonts.fontconfig.enable = true;

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Adwaita";
  #     package = pkgs.gnome3.gnome_themes_standard;
  #   };
  # };

  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-wayland;
    # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    #   forceWayland = true;
    #   extraPolicies = {
    #     ExtensionSettings = { };
    #   };
    # };
  };

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
  # xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  # xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  # xdg.configFile."nvim/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
  #
  xdg.configFile."nvim/lua".source = nvim/lua;

  xdg.configFile."helix/config.toml".text = "theme = \"bogster\"";
  programs.git = {
    enable = true;
    userEmail = "simonvoordouw@gmail.com";
    userName = "Simon Voordouw";
    extraConfig = {
      pull.rebase = "false";
      help.autocorrect = 10;
    };
  };

  programs.fish = {
    enable = true;
    functions = {
      bwu = "set -xU BW_SESSION (bw unlock --raw $argv[1])";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.bash.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    # MOZ_ENABLE_WAYLAND = 1;
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
    ZK_NOTEBOOK_DIR = "/home/simon/notes";
    # XCURSOR_PATH = lib.mkForce [ "${pkgs.gnome3.adwaita-icon-theme}/share/icons" ];
  };

  programs.taskwarrior = {
    enable = true;
    extraConfig = ''
      taskd.certificate=/home/simon/.config/taskwarrior/private.certificate.pem
      taskd.key=/home/simon/.config/taskwarrior/private.key.pem
      taskd.ca=/home/simon/.config/taskwarrior/ca.cert.pem
      taskd.server=inthe.am:53589
      taskd.credentials=inthe_am/simonvoordouw/3a2bfbe5-91a9-4a8f-8d8f-7404bb8f5fa6
      taskd.trust=ignore hostname
    '';
  };
  xdg.configFile."taskwarrior/private.certificate.pem".source = ./taskwarrior/private.certificate.pem;
  xdg.configFile."taskwarrior/private.key.pem".source = ./taskwarrior/private.key.pem;
  xdg.configFile."taskwarrior/ca.cert.pem".source = ./taskwarrior/ca.cert.pem;
}
