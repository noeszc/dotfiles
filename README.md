# dotfiles

Personal macOS configuration managed as symlinks.

## Fresh install

### 1. Xcode Command Line Tools

macOS doesn't ship with git or build tools. Install them first:

```bash
xcode-select --install
```

A dialog will appear — click **Install** and wait for it to finish. This gives you `git`, `make`, `curl`, and the compiler toolchain.

### 2. Clone this repo

```bash
git clone git@github.com:noeszc/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

> If you haven't set up SSH keys yet, clone with HTTPS instead:
> `git clone https://github.com/noeszc/dotfiles.git ~/dotfiles`

### 3. Install Homebrew

```bash
bash install/install-deps.sh
```

This installs Homebrew and then runs `brew bundle` against `install/Brewfile`,
which covers all CLI tools and GUI apps (Ghostty, Raycast, 1Password, etc.).

> After Homebrew installs on Apple Silicon, it will tell you to add it to your PATH.
> Add the following to your shell profile before continuing:
> ```bash
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

### 4. Create symlinks

```bash
bash install/bootsrap.sh
```

Reads every `links.prop` file in the repo and symlinks each entry into your home directory. If a file already exists it will ask what to do (skip / overwrite / backup).

### 5. Generate SSH keys

```bash
bash git/keygen.sh
```

Creates `~/.ssh/id_ed25519` (personal) and `~/.ssh/id_ed25519_work` (work),
adds both to the macOS keychain and SSH agent, and prints the public keys
ready to paste into GitHub.

See [git/README.md](git/README.md) for full details on the two-identity setup.

### 6. Apply macOS settings

```bash
bash install/macos.sh
```

Configures keyboard repeat rate, remaps Caps Lock → Escape, sets Finder to
column view, and disables the Spotlight shortcut (for Raycast).

> Requires sudo. Log out and back in for all changes to take effect.

### 7. Restart

Log out and back in (or reboot) so all system-level changes apply cleanly.

---

## Structure

```
dotfiles/
├── git/          # gitconfig, work identity, SSH config, keygen script
├── ghostty/      # terminal emulator config
├── nvim/         # Neovim config (lazy.nvim)
├── tmux/         # tmux config + tpm
├── zsh/          # shell config
└── install/      # Brewfile, bootstrap, macOS defaults
```

Each directory contains a `links.prop` that maps dotfiles → home directory paths.

## Day-to-day

| Task | Command |
|------|---------|
| Add a new symlink | Edit the relevant `links.prop`, re-run `bash install/bootsrap.sh` |
| Install a new brew package | Add to `install/Brewfile`, run `brew bundle --file install/Brewfile` |
| Switch work identity | Edit `git/work.gitconfig` with new email |
| New work SSH key | Run `bash git/keygen.sh` |
