#!/usr/bin/env bash

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"

brew bundle --file "$DOTFILES/install/Brewfile"
