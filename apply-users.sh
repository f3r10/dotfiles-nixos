#!/bin/sh

pushd ~/.dotfiles
nix build .#homeManagerConfigurations.f3r10.activationPackage
./result/activate
popd
