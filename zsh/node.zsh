# --- fnm (Fast Node Manager)
# This loads fnm and ensures the current node version is in your PATH
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# --- corepack for yarn (pnpm is installed via Homebrew, see install/Brewfile)
if command -v corepack &> /dev/null; then
  export COREPACK_HOME="$HOME/.cache/corepack"
  corepack enable yarn
fi


