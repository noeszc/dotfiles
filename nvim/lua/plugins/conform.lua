-- Filetypes that support project-level formatters (biome, oxfmt, prettierd)
local dynamic_ft = {
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "css",
}

-- Filetypes that always use prettierd (biome/oxfmt don't support these)
local prettier_only_ft = {
  "html",
  "postcss",
  "markdown",
  "yaml",
}

-- Detect which formatter to use based on project config files
local function get_js_formatters(bufnr)
  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  if buf_path == "" then return { "prettierd" } end

  local dir = vim.fs.dirname(buf_path)

  -- Biome takes priority
  local biome = vim.fs.find({ "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" }, {
    upward = true,
    path = dir,
    stop = vim.env.HOME,
    type = "file",
  })[1]
  if biome then return { "biome" } end

  -- OXC-based projects
  local oxfmt = vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }, {
    upward = true,
    path = dir,
    stop = vim.env.HOME,
    type = "file",
  })[1]
  if oxfmt then return { "oxfmt" } end

  -- Default
  return { "prettierd" }
end

local formatters_by_ft = {
  lua = { "stylua" },
}

for _, ft in ipairs(dynamic_ft) do
  formatters_by_ft[ft] = get_js_formatters
end

for _, ft in ipairs(prettier_only_ft) do
  formatters_by_ft[ft] = { "prettierd" }
end

return {
  "stevearc/conform.nvim",
  ft = vim.tbl_keys(formatters_by_ft),
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = formatters_by_ft,
    }

    local group = vim.api.nvim_create_augroup("NoeszcConfig", { clear = false })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      pattern = "*",
      callback = function(e)
        local filetype = vim.bo[e.buf].filetype

        if not formatters_by_ft[filetype] or vim.g.disable_autoformat then
          return
        end

        local client = vim.lsp.get_clients({ bufnr = e.buf, name = "eslint" })[1]

        ---@diagnostic disable-next-line: undefined-field
        if client then
          pcall(vim.lsp.buf.format, {
            async = false,
            timeout_ms = 4000,
          })
        end

        pcall(conform.format, {
          bufnr = e.buf,
          timeout_ms = 1000,
          lsp_fallback = true,
        })
      end,
    })

    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      print("Autoformat is now " .. (vim.g.disable_autoformat and "OFF" or "ON"))
    end, { desc = "Toggle autoformat on save" })
  end,
}
