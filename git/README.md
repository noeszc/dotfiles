# Git & SSH Configuration

Single SSH identity, with separate commit identities (personal and work) that
never conflict — same approach as [andrew8088/dotfiles](https://github.com/andrew8088/dotfiles).

## How it works

| File | Symlink | Purpose |
|------|---------|---------|
| `gitconfig` | `~/.gitconfig` | Global git config, personal identity by default |
| `ssh_config` | `~/.ssh/config` | Single SSH key for github.com |

`~/.work.gitconfig` is **not** part of this repo. It's a local, uncommitted
file that overrides `user.email` for work repos — created once per machine,
never symlinked, never pushed. Keeps company-specific info out of a dotfiles
repo other people can see.

### Identity switching

`~/.gitconfig` uses `includeIf` to automatically load `~/.work.gitconfig` for
any repo cloned inside `~/code/work/`:

```gitconfig
[includeIf "gitdir:~/code/work/"]
    path = ~/.work.gitconfig
```

Only one GitHub account/SSH key is needed as long as work repos are reachable
through that same account (e.g. added to an org as an outside collaborator or
member via your personal GitHub account). If a work repo ever lives under a
truly separate GitHub account, add a second SSH host alias in `ssh_config`
and rewrite the remote URL in `~/.work.gitconfig`, same as before.

## Setting up on a new machine

### 1. Generate an SSH key

```bash
bash git/keygen.sh
```

Creates `~/.ssh/id_ed25519`, adds it to the macOS keychain and SSH agent, and
prints the public key ready to paste into GitHub.

### 2. Add the public key to GitHub

[github.com/settings/ssh/new](https://github.com/settings/ssh/new)

### 3. Create your work identity

```bash
cat > ~/.work.gitconfig <<'EOF'
[user]
    name = Your Name
    email = you@company.com
EOF
```

### 4. Clone work repos inside `~/code/work/`

```bash
mkdir -p ~/code/work
git clone git@github.com:company/repo.git ~/code/work/repo
```

Git will automatically use the work identity for any repo under that path.

## Changing companies

Just edit the email in `~/.work.gitconfig` — nothing to touch in this repo.
