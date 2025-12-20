-- --- diagnostics configuration
vim.diagnostic.config {
  underline = true,
  -- custom symbols for the sign column
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },
  virtual_text = true, -- show error messages next to the code
  float = {
    show_header = true,
    source = true,       -- show the source of the diagnostic (e.g., lua_ls)
    border = "rounded",  -- use rounded corners for the floating window
    focusable = false,
    -- custom formatting to append the error code to the message
    format = function(d)
      local t = vim.deepcopy(d)
      local code = d.code or (d.user_data and d.user_data.lsp.code)
      if code and not string.find(t.message, code, 1, true) then
        t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
      end
      return t.message
    end,
  },
}))
