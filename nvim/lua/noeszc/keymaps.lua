-- --- neovim keymaps
local map = vim.keymap.set

-- clear search highlight on esc
map("n", "<ESC>", ":nohl <ESC>", { silent = true })

-- disable ex mode (prevents accidental triggers)
map("", "Q", "<NOP>")

-- --- system clipboard (using 'g' prefix)
-- yank to system clipboard
map({ "n", "v" }, "gy", '"+y', { silent = true })
map({ "n", "v" }, "gY", '"+Y', { silent = true })

-- paste from system clipboard
map({ "n", "v" }, "gp", '"+p', { silent = true })
map({ "n", "v" }, "gP", '"+P', { silent = true })

-- --- centered navigation
-- keep cursor in the middle when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- keep cursor in the middle when jumping half-pages
map("n", "<C-d>", "<C-d>zzzv")
map("n", "<C-u>", "<C-u>zzzv")
