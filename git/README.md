# Git & SSH Configuration

Supports two separate identities (personal and work) that never conflict.

## How it works

| File | Symlink | Purpose |
|------|---------|---------|
| `gitconfig` | `~/.gitconfig` | Global git config, personal identity by default |
| `work.gitconfig` | `~/.work.gitconfig` | Work identity, loaded automatically for repos in `~/code/work/` |
| `ssh_config` | `~/.ssh/config` | SSH host aliases to route each identity to the correct key |

### Identity switching

`~/.gitconfig` uses `includeIf` to automatically load `work.gitconfig` for any
repo cloned inside `~/code/work/`:

```gitconfig
[includeIf "gitdir:~/code/work/"]
    path = ~/.work.gitconfig
```

`work.gitconfig` also rewrites `github.com` URLs to the `github-work` SSH alias
so the correct key is always used without any manual intervention:

```gitconfig
[url "git@github-work:"]
    insteadOf = git@github.com:
```

## Setting up on a new machine

### 1. Generate SSH keys

```bash
bash git/keygen.sh
```

The script will:
- Create `~/.ssh/id_ed25519` for personal use
- Create `~/.ssh/id_ed25519_work` for work (prompts for email)
- Add both to the macOS keychain and SSH agent
- Print the public keys ready to paste into GitHub

### 2. Add public keys to GitHub

- **Personal** → [github.com/settings/ssh/new](https://github.com/settings/ssh/new)
- **Work** → your company's GitHub account SSH settings

### 3. Update work identity

Edit `git/work.gitconfig` with your work name and email:

```gitconfig
[user]
    name = Your Name
    email = you@company.com
```

### 4. Verify

```bash
ssh -T git@github.com       # should greet your personal account
ssh -T git@github-work      # should greet your work account
```

### 5. Clone work repos inside `~/code/work/`

```bash
mkdir -p ~/code/work
git clone git@github.com:company/repo.git ~/code/work/repo
```

Git will automatically use your work identity and the correct SSH key.

## Changing companies

1. Update `email` in `git/work.gitconfig`
2. Run `bash git/keygen.sh` to generate a new work key (skip personal if it already exists)
3. Add the new public key to the new company's GitHub
4. Verify with `ssh -T git@github-work`
