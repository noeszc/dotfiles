return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
		"j-hui/fidget.nvim",
		{ "folke/lazydev.nvim", ft = "lua" },
		"folke/snacks.nvim",
	},
	event = "BufReadPre",
	cmd = "Mason",
	config = function()
		local snacks = require("snacks")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tools = require("mason-tool-installer")

		local ensure_installed = {
			"stylua",
			"luacheck",
			"prettierd",
			"lua_ls",
			"vtsls",
			"eslint",
			"stylelint_lsp",
			"tailwindcss",
			"cssmodules_ls",
			"emmet_ls",
			"html",
			"jsonls",
		}

		require("mason").setup()
		mason_tools.setup({
			ensure_installed = ensure_installed,
			auto_update = false,
			run_on_start = true,
			start_delay = 1000,
		})
		-- mason_tools.run_on_start()

		-- Optimize Lua LSP for Neovim development
		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})

		mason_lspconfig.setup()

		-- Get capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Custom server settings
		local server_configs = {
			stylelint_lsp = {
				filetypes = { "css", "less", "postcss", "scss" },
			},
			lua_ls = {
				settings = {
					Lua = { diagnostics = { globals = { "vim" } } },
				},
			},
			tailwindcss = {
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							},
						},
					},
				},
			},
			emmet_ls = {
				filetypes = { "html", "css", "scss", "less" },
			},
		}

		-- --- New Native LSP Config (Neovim 0.11+)
		-- We iterate through servers and use vim.lsp.config instead of lspconfig
		for _, name in pairs(mason_lspconfig.get_installed_servers()) do
			local config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
			}, server_configs[name] or {})

			-- Apply the config to the server name
			vim.lsp.config(name, config)
			-- Enable the server (this replaces .setup())
			vim.lsp.enable(name)
		end

		require("fidget").setup({})

		-- Load your custom diagnostic config
		require("noeszc.diagnostic")

		local group = vim.api.nvim_create_augroup("NoeszcConfig", { clear = true })

		-- --- LSP keymaps and behavior
		vim.api.nvim_create_autocmd("LspAttach", {
			group = group,
			callback = function(event)
				local picker_opts = { layout = { preset = "ivy" } }

				local function map(keys, func, mode)
					vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, remap = true })
				end

				-- Navigation using snacks picker
				map("gd", function()
					snacks.picker.lsp_definitions(picker_opts)
				end)
				map("gvd", function()
					snacks.picker.lsp_definitions(vim.tbl_deep_extend("force", {}, picker_opts, {
						confirm = "edit_vsplit",
					}))
				end)
				map("grr", function()
					snacks.picker.lsp_references(picker_opts)
				end)
				map("gI", function()
					snacks.picker.lsp_implementations(picker_opts)
				end)
				map("<leader>D", function()
					snacks.picker.lsp_type_definitions(picker_opts)
				end)

				-- Standard LSP actions
				map("<leader>rn", vim.lsp.buf.rename)
				map("<leader>ca", vim.lsp.buf.code_action, { "n", "x" })
				map("gD", vim.lsp.buf.declaration)
				map("K", function()
					vim.lsp.buf.hover({ border = "rounded" })
				end)
				map("<leader>e", vim.diagnostic.open_float)

				-- --- Document highlighting
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("NoeszcConfigHighlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = group,
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "NoeszcConfigHighlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})
	end,
}
