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
			"rose-pine/neovim",
			name = "rose-pine",
			priority = 1000, -- Load early to avoid flashing
			config = function()
				require("rose-pine").setup({
					variant = "main", -- main, moon, or dawn
					dark_variant = "main",
					styles = {
						italic = true,
						bold = true,
						transparency = false,
					},
					-- This is the key part: Linking TS groups to standard ones
					highlight_groups = {
						-- Standard Keywords
						["@keyword"] = { fg = "pine" },
						["@storageclass"] = { fg = "pine" }, -- const, let, var

						-- TypeScript & React Specifics
						["typescriptVariable"] = { link = "Keyword" },
						["typescriptImport"] = { link = "Keyword" },
						["typescriptExport"] = { link = "Keyword" },
						["typescriptPredefinedType"] = { fg = "iris" },
						["@type.builtin.typescript"] = { fg = "iris" },

						-- LSP Semantic Tokens (Fix for the white keywords)
						["@lsp.type.keyword"] = { link = "Keyword" },
						["@lsp.type.storageClass"] = { link = "Keyword" },
					},
				})

				vim.cmd("colorscheme rose-pine")
			end,
		},
		-- {
		-- 	"catppuccin/nvim",
		-- 	name = "catppuccin",
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	config = function()
		-- 		vim.g.catppuccin_flavour = "mocha"
		--
		-- 		local colors = require("catppuccin.palettes").get_palette()
		-- 		require("catppuccin").setup({
		-- 			custom_highlights = {
		-- 				LineNr = { fg = colors.overlay1 },
		-- 			},
		-- 		})
		--
		-- 		vim.cmd.colorscheme("catppuccin")
		-- 	end,
		-- },
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
