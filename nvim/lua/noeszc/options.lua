-- --- neovim options
local set = vim.opt

-- appearance
set.termguicolors = true  -- enable true color support
set.splitbelow = false
set.signcolumn = "yes"
set.relativenumber = true -- relative line numbers for faster jumps
set.colorcolumn = "100"   -- visual guide for line length limit

-- indents & tabs
set.tabstop = 2           -- one tab is 2 spaces
set.shiftwidth = 2        -- indentation size
set.expandtab = true      -- use spaces instead of tabs

-- performance & backup
set.swapfile = false      -- do not create .swp files
set.backup = false        -- do not create backup files
set.writebackup = false

-- behavior
set.diffopt:append "vertical" -- always use vertical splits for diffs
set.inccommand = "split"      -- preview substitutions (:%s) in a split window

-- wrapping (comfortable reading)
set.textwidth = 0
set.wrapmargin = 0
set.wrap = true
set.linebreak = true      -- don't break words in the middle when wrapping

-- --- autocommands
local group = vim.api.nvim_create_augroup("NoeszcConfig", { clear = true })

-- visual feedback on yank (copy)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
  group = group,
})
