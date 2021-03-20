{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neuron-notes-git = {
      url = "github:srid/neuron";
      flake = false;
    };
    neuron-nvim = {
      url = "github:oberblastmeister/neuron.nvim/unstable";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.simon-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.neovim-nightly-overlay.overlay
            (final: prev: {
              neuron-notes =
                (prev.callPackage "${inputs.neuron-notes-git}/project.nix"
                  { }).neuron;
            })
            (final: prev: {
              neuron-nvim = prev.vimUtils.buildVimPlugin {
                name = "neuron-nvim";
                src = inputs.neuron-nvim;
                dontBuild = true;
              };
            })
            (final: prev: {
              rnix-lsp = inputs.rnix-lsp.defaultPackage."${final.system}";
            })
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.simon = import ./home.nix;
          nix.registry.nixpkgs.flake = nixpkgs;
        }
      ];
    };
  };
}
