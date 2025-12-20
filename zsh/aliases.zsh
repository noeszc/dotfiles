# --- system & nav
alias c='clear'
alias s='source ~/.zshrc'
alias l='eza -lah'
alias ls='eza'
alias sl='eza'
alias rm='trash'
alias unmount_all_and_exit='unmount_all && exit'
alias trim="awk '{\$1=\$1;print}'"

# --- editors & notes
alias v='nvim -w ~/.vimlog "$@"'
alias vi='nvim -w ~/.vimlog "$@"'
alias vim='nvim -w ~/.vimlog "$@"'
alias zn='vim $notes_dir/$(date +"%y%m%d%h%m.md")'
alias notes="cd $notes_dir && nvim 00\ home.md"

# --- tools
alias ta='tmux attach -t'
alias jj='pbpaste | jsonpp | pbcopy'

# --- git core
alias gst='git rev-parse --git-dir > /dev/null 2>&1 && git status || eza'
alias ga='git add'
alias gc='git commit'
alias gcan='gc --amend --no-edit'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -d'
alias gcp='git cherry-pick'
alias gg='git branch | fzf | xargs git checkout'

# --- git diffs & push
alias gd='git diff -w'
alias gds='git diff -w --staged'
alias grs='git restore --staged'
alias gu='git reset --soft head~1'
alias gpr='git remote prune origin'
alias ff='gpr && git pull --ff-only'
alias gp="script -qec 'git push -u' /dev/null 2>&1 | tee >(cat) | grep 'pull/new' | awk '{print \$2}' | xargs xdg-open"
alias gpf='git push --force-with-lease'

# --- git rebase & branches
alias grd='git fetch origin && git rebase origin/master'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gup='git branch --set-upstream-to=origin/$(git-current-branch) $(git-current-branch)'
alias gbb='git-switchbranch'
alias gbf='git branch | head -1 | xargs'
alias gbdd='git-branch-utils -d'
alias gbuu='git-branch-utils -u'
alias gbrr='git-branch-utils -r -b develop'

# --- git logs & nav
alias gl=pretty_git_log
alias gla=pretty_git_log_all
alias git-current-branch="git branch | grep \* | cut -d ' ' -f2"
alias gnext='git log --ancestry-path --format=%h ${commit}..master | tail -1 | xargs git checkout'
alias gprev='git checkout head^'
alias gec='git status | grep "both modified:" | cut -d ":" -f 2 | trim | xargs nvim -'

# --- functions
take() { mkdir -p "$1" && cd "$1"; }
note() { echo "date: $(date)\n$@\n" >> $home/drafts.txt; }
hs() { curl "https://httpstat.us/$1"; }

mff() {
    local curr_branch=$(git-current-branch)
    gco master && ff && gco $curr_branch
}

unmount_all() {
    diskutil list | grep external | cut -d ' ' -f 1 | while read file; do
        diskutil unmountdisk "$file"
    done
}

extract-audio-and-video() {
    ffmpeg -i "$1" -c:a copy obs-audio.aac
    ffmpeg -i "$1" -c:v copy obs-video.mp4
}
