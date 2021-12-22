_: pkgs: rec {
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
      (self: super: rec {
        f3r10-taffybar = self.callCabal2nix "f3r10-taffybar"
          (pkgs.lib.sourceByRegex ../config/f3r10-taffybar [
            "taffybar.hs"
            "taffybar.css"
            "icy-palette.css"
            "f3r10-taffybar.cabal"
          ]) { };
      });
  });
}
