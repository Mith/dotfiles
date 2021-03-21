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
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    msbuild-upgrade.url = "github:corngood/nixpkgs/msbuild";
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

              neuron-nvim = prev.vimUtils.buildVimPlugin {
                name = "neuron-nvim";
                src = inputs.neuron-nvim;
                dontBuild = true;
              };

              rnix-lsp = inputs.rnix-lsp.defaultPackage."${final.system}";
              msbuild = (import inputs.msbuild-upgrade { system = "x86_64-linux"; }).msbuild;
              omnisharp-roslyn = prev.omnisharp-roslyn.overrideAttrs (oldAttrs: rec {
                version = "1.37.7";
                src = prev.fetchurl {
                  url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.37.7/omnisharp-mono.tar.gz";
                  sha256 = "sha256-0KoF0LnFaIzykcLcMlXMR+H6eh4p/xVqV0ONXB0aTiY=";
                };
                nativeBuildInputs = with final; [ makeWrapper dotnet-sdk_5 dotnetPackages.Nuget ];
                installPhase = ''
                  mkdir -p $out/bin
                  cd ..
                  cp -r src $out/
                  rm -r $out/src/.msbuild
                  cp -r ${final.msbuild}/lib/mono/msbuild $out/src/.msbuild
                  chmod -R u+w $out/src
                  mv $out/src/.msbuild/Current/{bin,Bin}
                  makeWrapper ${final.mono6}/bin/mono $out/bin/omnisharp \
                  --add-flags "$out/src/OmniSharp.exe"
                '';
              });
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
