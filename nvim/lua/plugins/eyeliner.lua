return {
  "jinh0/eyeliner.nvim",
  -- lazy load only when you start navigating horizontally
  keys = { "f", "F", "t", "T" },
  config = function()
    require("eyeliner").setup {
      highlight_on_key = true, -- only show highlights after pressing f/F/t/T
      match = "[%w]",          -- match alphanumeric characters
    }

    -- custom high-visibility colors
    -- Primary: The unique character to jump directly to the word
    vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ff0000", underline = true })
    -- Secondary: Other unique characters in the line
    vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#5fffff", underline = true })
  end,
}
