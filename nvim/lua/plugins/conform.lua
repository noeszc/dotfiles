local formatters_by_ft = {
  lua = { "stylua" },
}

local prettierd_ft = {
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
  "html",
  "css",
  "postcss", -- fixed typo: postcsss -> postcss
  "markdown",
  "json",
  "yaml",
}

-- batch assign prettierd to all relevant filetypes
for _, ft in ipairs(prettierd_ft) do
  formatters_by_ft[ft] = { "prettierd" }
end

return {
  "stevearc/conform.nvim",
  -- lazy load on filetypes that have a formatter
  ft = vim.tbl_keys(formatters_by_ft),
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = formatters_by_ft,
    }

    local group = vim.api.nvim_create_augroup("NoeszcConfig", { clear = false })

    -- --- format on save logic
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      pattern = "*",
      callback = function(e)
        local filetype = vim.bo[e.buf].filetype

        -- skip if no formatter is defined or if autoformat is globally disabled
        if not formatters_by_ft[filetype] or vim.g.disable_autoformat then
          return
        end

        -- handle eslint specifically if the client is active
        local client = vim.lsp.get_clients({ bufnr = e.buf, name = "eslint" })[1]

        ---@diagnostic disable-next-line: undefined-field
        if client then
          pcall(vim.lsp.buf.format, {
            async = false,
            timeout_ms = 4000,
          })
        end

        -- perform conform formatting
        pcall(conform.format, {
          bufnr = e.buf,
          timeout_ms = 1000,
          lsp_fallback = true, -- use LSP formatter if conform formatter is unavailable
        })
      end,
    })

    -- custom command to toggle autoformat on/off
    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      print("Autoformat is now " .. (vim.g.disable_autoformat and "OFF" or "ON"))
    end, { desc = "Toggle autoformat on save" })
  end,
}
