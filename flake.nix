{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      master = import inputs.nixpkgs-master { system = "${system}"; config.allowUnfree = true; };
    in
    {
      nixosConfigurations.simon-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              # inputs.neovim-nightly-overlay.overlay
              # (self: super:
              #   let
              #     plugin = name: super.vimUtils.buildVimPlugin {
              #       pname = "${name}";
              #       version = "HEAD";
              #       src = inputs.${name};
              #       dontBuild = true;
              #     };
              #   in
              #   {
              #     vimPlugins = super.vimPlugins // { inherit (plugin "rust-tools-nvim"); };
              #   }
              # )
              (final: prev: rec {
                rnix-lsp = inputs.rnix-lsp.defaultPackage."${final.system}";
                steamPackages = master.steamPackages;
              })
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.simon = import ./home.nix;
            nix.registry.nixpkgs.flake = nixpkgs;
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
