# --- fnm (Fast Node Manager)
# This loads fnm and ensures the current node version is in your PATH
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# --- corepack for pnpm and yarn
if command -v corepack &> /dev/null; then
  export COREPACK_HOME="$HOME/.cache/corepack"
  # enables pnpm and yarn based on the current node version
  corepack enable pnpm yarn
fi


