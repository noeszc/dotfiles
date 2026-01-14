local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("noeszc.options")
require("noeszc.keymaps")

require("lazy").setup({
	spec = {
		{
			"cdmill/neomodern.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("neomodern").setup({
					theme = "iceclimber", -- iceclimber | gyokuro | hojicha | roseprime
					code_style = {
						comments = "none",
						conditionals = "none",
						functions = "none",
						keywords = "none",
						strings = "none",
						variables = "none",
					},
				})
				require("neomodern").load()
			end,
		},
		-- --- smart commenting based on treesitter
		{ "folke/ts-comments.nvim", opts = {}, event = "BufReadPre" },

		-- --- highlight and search for TODO, FIX, HACK, etc.
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {},
			event = "BufReadPre",
		},

		-- --- seamless navigation between nvim splits and tmux panes
		{
			"christoomey/vim-tmux-navigator",
			keys = {
				-- silent = true ensures the command doesn't echo in the command line
				{ "<C-H>", "<cmd><C-U>TmuxNavigateLeft<cr>", silent = true },
				{ "<C-J>", "<cmd><C-U>TmuxNavigateDown<cr>", silent = true },
				{ "<C-K>", "<cmd><C-U>TmuxNavigateUp<cr>", silent = true },
				{ "<C-L>", "<cmd><C-U>TmuxNavigateRight<cr>", silent = true },
			},
		},
		{ import = "plugins" },
	},
	defaults = { lazy = false },
	install = { colorscheme = { "tokyonight-moon" } },
})
