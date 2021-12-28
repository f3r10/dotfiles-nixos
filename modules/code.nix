{ pkgs, ... }: {

  home-manager.users.f3r10.home.packages = with pkgs; [
    # Haskell
    cabal-install
    cabal2nix
    ghc
    stack
    haskellPackages.haskell-language-server
    haskellPackages.hpack
    haskellPackages.hasktags
    haskellPackages.hoogle
    haskellPackages.ghcid
  ];
}
