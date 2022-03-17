#!/bin/sh

git clone https://github.com/zplug/zplug ~/zplug

git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.0

source $HOME/.asdf/asdf.sh

asdf plugin add nodejs
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 16.13.1
asdf global nodejs $(asdf list nodejs | tail -1 | sed 's/^ *//g')

npm install -g neovim
