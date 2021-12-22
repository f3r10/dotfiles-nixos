{
  inputs = {
    # taffybar.url = "github:taffybar/taffybar/cryptoWidget";
    taffybar.url = "github:taffybar/taffybar";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, taffybar, nixpkgs }:

    let
      overlay = import ../../overlays/taffybar.nix;
      overlays = taffybar.overlays ++ [ overlay ];

    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowBroken = true;
        };
      in rec {
        devShell = pkgs.haskellPackages.shellFor {
          packages = p: [ p.f3r10-taffybar ];
        };
        defaultPackage = pkgs.haskellPackages.f3r10-taffybar;
      }) // {
        inherit overlay overlays;
      };
}
