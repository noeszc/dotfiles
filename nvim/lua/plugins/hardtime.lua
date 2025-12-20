return {
  "takac/vim-hardtime",
  lazy = false,
  init = function()
    -- enable hardtime by default on startup
    vim.g.hardtime_default_on = 1
  end,
  config = function()
    -- maximum number of consecutive key presses allowed
    vim.g.hardtime_maxcount = 2
    vim.g.hardtime_ignore_quickfix = 1

    -- keys to monitor and restrict in normal mode
    vim.g.list_of_normal_keys = { 
      "h", "j", "k", "l", 
      "<LEFT>", "<UP>", "<DOWN>", "<RIGHT>", 
      "w", "W", "b", "B" 
    }

    -- restrict arrow keys in insert mode to build better habits
    vim.g.list_of_insert_keys = { "<LEFT>", "<UP>", "<DOWN>", "<RIGHT>" }

    -- ignore hardtime in specific buffers where frequent movement is necessary
    vim.g.hardtime_ignore_buffer_patterns = {
      "fugitive://.*",           -- git fugitive buffers
      "\\.git/.*/\\?index",      -- git index
      "\\.git/COMMIT_EDITMSG",   -- commit messages
      "\\.git/rebase-merge.*",   -- interactive rebases
      "undotree_2",              -- undotree panel
      "runtime/doc/.*.txt",      -- vim documentation
    }
  end,
}
