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
bash install/homebrew.sh
```

When it finishes, the installer prints a few `echo` commands — **run them**.
They add Homebrew to your `.zprofile` so it's available in future sessions.
Then open a new terminal window before continuing.

### 4. Install packages

```bash
bash install/packages.sh
```

Runs `brew bundle` against `install/Brewfile` — installs all CLI tools and GUI
apps (Ghostty, Raycast, Bitwarden, etc.).

### 5. Create symlinks

```bash
bash install/bootsrap.sh
```

Reads every `links.prop` file in the repo and symlinks each entry into your home directory. If a file already exists it will ask what to do (skip / overwrite / backup).

### 6. Generate an SSH key

```bash
bash git/keygen.sh
```

Creates `~/.ssh/id_ed25519`, adds it to the macOS keychain and SSH agent, and
prints the public key ready to paste into GitHub.

See [git/README.md](git/README.md) for full details on the identity setup,
including how to add a separate work commit identity.

### 7. Apply macOS settings

```bash
bash install/macos.sh
```

Configures keyboard repeat rate, remaps Caps Lock → Escape, sets Finder to
column view, and disables the Spotlight shortcut (for Raycast).

> Requires sudo. Log out and back in for all changes to take effect.

### 8. Restart

Log out and back in (or reboot) so all system-level changes apply cleanly.

---

## Structure

```
dotfiles/
├── git/          # gitconfig, SSH config, keygen script
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
| Switch work identity | Edit `~/.work.gitconfig` with new email |
| New SSH key | Run `bash git/keygen.sh` |
