{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # neovim-nightly.url = "github:neovim/neovim?dir=contrib";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    {
      nixosConfigurations.simon-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.simon = import ./home.nix;
          }
        ];
      };
    };
}
