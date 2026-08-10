#!/usr/bin/env bash
#
# Generates an SSH key for GitHub and adds it to the macOS keychain + agent.

set -e

info()    { printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"; }
success() { printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"; }

KEY="$HOME/.ssh/id_ed25519"
EMAIL="noeszc@gmail.com"

if [ -f "$KEY" ]; then
  info "Key already exists at $KEY, skipping"
else
  info "Generating SSH key..."
  ssh-keygen -t ed25519 -f "$KEY" -C "$EMAIL"
  success "Key created"
fi

info "Adding key to SSH agent and macOS keychain..."
ssh-add --apple-use-keychain "$KEY" 2>/dev/null && success "Key added to agent"

echo ''
info "Copy your public key and add it to GitHub:"
echo ''
echo "  https://github.com/settings/ssh/new"
echo "  $(cat "${KEY}.pub")"
echo ''
success "Done! Verify with: ssh -T git@github.com"
