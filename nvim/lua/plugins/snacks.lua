local map = vim.keymap.set

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require "snacks"
    
    snacks.setup {
      input = { enabled = true },        -- better UI for vim.ui.input
      image = { enabled = true },        -- image support in terminal
      notifier = { enabled = true },     -- pretty notifications
      statuscolumn = { enabled = true }, -- modern gutter (signs + fold + numbers)
      indent = {
        enabled = true,
        animate = { enabled = false },   -- performance over fancy animations
      },
      picker = { enabled = true },       -- fast file/text finder
      gitbrowse = {},                    -- open current file in GitHub/GitLab
      rename = { enabled = true },       -- LSP integrated renaming
    }

    -- --- picker keymaps
    -- find files (including hidden ones)
    map("n", "<C-P>", function()
      snacks.picker.files { hidden = true }
    end, { desc = "Find Files" })

    -- live grep (search text inside files)
    map("n", "<C-F>", function()
      snacks.picker.grep { hidden = true }
    end, { desc = "Grep Text" })

    -- list open buffers
    map("n", "<leader>b", function()
      snacks.picker.buffers()
    end, { desc = "Buffers" })

    -- search help tags
    map("n", "<leader>h", function()
      snacks.picker.help()
    end, { desc = "Help Tags" })

    -- --- git keymaps
    -- open current line/file in browser
    map("n", "<leader>go", function()
      snacks.gitbrowse.open()
    end, { desc = "Git Browse (Open in Browser)" })

    -- --- autocommands
    local highlight_augroup = vim.api.nvim_create_augroup("NoeszcHighlight", { clear = true })
    
    -- abbreviation to make ripgrep globbing easier in the picker
    -- typing '-g' will expand to '-- -g' automatically
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "snacks_picker_input" },
      group = highlight_augroup,
      callback = function()
        vim.cmd.iabbrev("-g", "-- -g")
      end,
    })
  end,
}
