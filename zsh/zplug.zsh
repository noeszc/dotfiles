source ~/zplug/init.zsh



# Sorted in order of appearance (new at the bottom):
zplug "zsh-users/zsh-syntax-highlighting"

zplug "lib/history", from:oh-my-zsh

# Theme, should be the last:
# zplug "geometry-zsh/geometry"
zplug "sobolevn/sobole-zsh-theme", from:github, as:theme
  

if ! zplug check; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load
if ! zplug check; then
    zplug install
fi

zplug load
