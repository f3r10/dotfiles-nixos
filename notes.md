* Flakes
`nixos-rebuild build --flake .#` will generate the flake.block and a result folder from which it is possible to apply the configuration with `sudo nixos-rebuild switch --flake .#`
