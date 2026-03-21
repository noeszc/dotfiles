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
			"everviolet/nvim",
			name = "evergarden",
			lazy = false,
			priority = 1000,
			opts = {
				theme = {
					variant = "spring",
					accent = "green",
				},
			},
			config = function(_, opts)
				require("evergarden").setup(opts)
				vim.cmd.colorscheme("evergarden")
			end,
		},
		-- --- sync colorscheme with system dark/light mode
		{
			"f-person/auto-dark-mode.nvim",
			opts = {
				update_interval = 1000,
				set_dark_mode = function()
					require("evergarden").setup({
						theme = { variant = "fall", accent = "green" },
						editor = {
							transparent_background = false,
							sign = { color = "none" },
							float = { color = "mantle", solid_border = false },
							completion = { color = "surface0" },
						},
					})
					vim.cmd.colorscheme("evergarden")
				end,
				set_light_mode = function()
					require("evergarden").setup({
						theme = { variant = "spring", accent = "green" },
						editor = {
							transparent_background = false,
							sign = { color = "none" },
							float = { color = "mantle", solid_border = false },
							completion = { color = "surface0" },
						},
					})
					vim.cmd.colorscheme("evergarden")
				end,
			},
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
