_: pkgs: rec {
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
      (self: super: rec {
        f3r10-xmonad = self.callCabal2nix "f3r10-xmonad"
          (pkgs.lib.sourceByRegex ../config/xmonad [
            "xmonad.hs"
            "f3r10-xmonad.cabal"
          ])
          { };
      });
  });
}
