{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    # in this way home-manager will have the same package version thant nixpkgs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad.url = "github:xmonad/xmonad";
    xmonad-contrib = {
      url = "github:xmonad/xmonad-contrib";
      inputs.xmonad.follows = "xmonad";
    };
    xmobar.url = "github:alternateved/xmobar";
  };

  outputs = { nixpkgs, home-manager, nur, neovim-nightly-overlay, xmonad, xmonad-contrib,
  xmobar,  ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [
        # nur.overlay
        neovim-nightly-overlay.overlay
        xmonad.overlay
        xmonad-contrib.overlay
        xmobar.overlay
        (import ./overlays)
      ];
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit pkgs system;

        modules = [
          ./modules/code.nix
          ./system/configuration.nix
          ./modules/alacritty
          ./modules/shell/fish.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.f3r10 = import ./users/f3r10/home.nix;
          }
          /* {
            modules = {
              terminal = {
                enable = true;
                mainWorkspaceDir = "$HOME/f3r10";
              };
            };
          } */
        ];
      };
    };
  };
}
