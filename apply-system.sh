#!/bin/sh

pushd ~/.dotfiles
nixos-rebuild build --flake .#
sudo nixos-rebuild switch --flake .#
popd
