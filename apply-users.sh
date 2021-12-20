#!/bin/sh

pushd ~/.dotfiles
home-manager switch -f ./users/f3r10/home.nix
popd
