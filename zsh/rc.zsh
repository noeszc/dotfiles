source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

export ZPLUG_HOME=$(brew --prefix)/opt/zplug
if [ -f $ZPLUG_HOME/init.zsh ]; then
    source $ZPLUG_HOME/init.zsh
fi

zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "lib/history", from:oh-my-zsh
# zplug "sobolevn/sobole-zsh-theme", from:github, as:theme
zplug "subnixr/minimal", from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check; then
    printf "Instalando plugins de zplug...\n"
    zplug install
fi

zplug load

source_if_exists $HOME/.env.sh
source_if_exists $HOME/.cargo/bin
source_if_exists $DOTFILES/zsh/secrets.zsh
source_if_exists $DOTFILES/zsh/git.zsh
source_if_exists ~/.fzf.zsh
source_if_exists $DOTFILES/zsh/aliases.zsh
source_if_exists $DOTFILES/zsh/node.zsh

if type "zoxide" > /dev/null; then
    eval "$(zoxide init zsh)"
fi

if type "direnv" > /dev/null; then
    eval "$(direnv hook zsh)"
fi
autoload -U zmv
autoload -U promptinit && promptinit
autoload -U colors && colors
autoload -Uz compinit && compinit

SOBOLE_THEME_MODE='light'
export VISUAL=nvim
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH:/usr/local/sbin:$DOTFILES"


