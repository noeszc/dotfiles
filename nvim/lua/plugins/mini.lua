return {
	"echasnovski/mini.nvim",
	lazy = false,
	priority = 1000, -- load early for statusline and icons
	config = function()
		-- --- basic settings and better mappings
		require("mini.basics").setup({
			options = { basic = true },
			mappings = {
				basic = true,
				windows = true,
				move_with_alt = true,
			},
		})

		-- --- essentials
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.ai").setup() -- enhanced text objects (a/i)
		require("mini.surround").setup() -- add/delete/replace surroundings (sa/sd/sr)
		require("mini.pairs").setup() -- auto-close brackets/quotes

		-- text operators (replace and sort)
		require("mini.operators").setup({
			replace = { prefix = "gs" }, -- use gs to replace text with register
			sort = { prefix = "" }, -- sort disabled by default
		})

		-- visual move (Alt + keys)
		require("mini.move").setup({
			mappings = {
				left = "ķ",
				right = "ł",
				down = "∆",
				up = "Ż",
				line_left = "ķ",
				line_right = "ł",
				line_down = "∆",
				line_up = "Ż",
			},
		})
	end,
}
