#!/usr/bin/env bash
#
# Generates SSH keys for personal and work GitHub accounts
# and adds them to the macOS keychain + SSH agent.

set -e

info()    { printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"; }
success() { printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"; }
fail()    { printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"; echo ''; exit 1; }

# --- Personal key
PERSONAL_KEY="$HOME/.ssh/id_ed25519"
PERSONAL_EMAIL="noeszc@gmail.com"

if [ -f "$PERSONAL_KEY" ]; then
  info "Personal key already exists at $PERSONAL_KEY, skipping"
else
  info "Generating personal SSH key..."
  ssh-keygen -t ed25519 -f "$PERSONAL_KEY" -C "$PERSONAL_EMAIL"
  success "Personal key created"
fi

# --- Work key
WORK_KEY="$HOME/.ssh/id_ed25519_work"

read -rp "  Enter your work email: " WORK_EMAIL
if [ -z "$WORK_EMAIL" ]; then
  fail "Work email cannot be empty"
fi

if [ -f "$WORK_KEY" ]; then
  info "Work key already exists at $WORK_KEY, skipping"
else
  info "Generating work SSH key..."
  ssh-keygen -t ed25519 -f "$WORK_KEY" -C "$WORK_EMAIL"
  success "Work key created"
fi

# --- Add to agent + keychain
info "Adding keys to SSH agent and macOS keychain..."
ssh-add --apple-use-keychain "$PERSONAL_KEY" 2>/dev/null && success "Personal key added to agent"
ssh-add --apple-use-keychain "$WORK_KEY"     2>/dev/null && success "Work key added to agent"

echo ''
info "Copy your public keys and add them to GitHub:"
echo ''
echo "  Personal → https://github.com/settings/ssh/new"
echo "  $(cat "${PERSONAL_KEY}.pub")"
echo ''
echo "  Work → Add to your work GitHub account"
echo "  $(cat "${WORK_KEY}.pub")"
echo ''
success "Done! Verify with: ssh -T git@github.com && ssh -T git@github-work"
