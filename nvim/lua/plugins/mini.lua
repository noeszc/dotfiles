return {
	"echasnovski/mini.nvim",
	lazy = false,
	priority = 1000, -- Load early for statusline and icons
	config = function()
		local map = vim.keymap.set

		-- --- Basic settings (disable move_with_alt to avoid conflict)
		require("mini.basics").setup({
			options = { basic = true },
			mappings = {
				basic = true,
				windows = true,
				move_with_alt = false,
			},
		})

		-- --- Essentials
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.ai").setup() -- Enhanced text objects (a/i)
		require("mini.surround").setup() -- Surround actions (sa/sd/sr)
		require("mini.pairs").setup() -- Auto-close brackets/quotes
		require("mini.files").setup() -- File explorer

		-- Text operators
		require("mini.operators").setup({
			replace = { prefix = "gs" }, -- Replace text with register
			sort = { prefix = "" }, -- Sort disabled
		})

		-- --- Visual move (Alt + keys) optimized for Ghostty
		require("mini.move").setup()

		-- --- MiniFiles Keymaps
		map("n", "<leader>nn", function()
			MiniFiles.open()
		end, { desc = "Open explorer" })
		map("n", "<leader>nf", function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
		end, { desc = "Open explorer at current file" })

		-- Helper to open files in splits from MiniFiles
		local map_split = function(buf_id, lhs, direction)
			local rhs = function()
				local cur_target = MiniFiles.get_explorer_state().target_window
				local new_target = vim.api.nvim_win_call(cur_target, function()
					vim.cmd(direction .. " split")
					return vim.api.nvim_get_current_win()
				end)
				MiniFiles.set_target_window(new_target)
				MiniFiles.go_in({ close_on_file = true })
			end
			vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Open in split" })
		end

		-- Apply split mappings inside MiniFiles buffers
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesBufferCreate",
			callback = function(args)
				local buf_id = args.data.buf_id
				map_split(buf_id, "<C-s>", "belowright horizontal")
				map_split(buf_id, "<leader>v", "belowright vertical")
			end,
		})

		-- --- Snacks Integration: Auto-update imports on rename
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				require("snacks").rename.on_rename_file(event.data.from, event.data.to)
			end,
		})
	end,
}
