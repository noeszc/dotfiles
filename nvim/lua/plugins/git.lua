return {
  "tpope/vim-fugitive",
  dependencies = { 
    "akinsho/git-conflict.nvim", 
    "lewis6991/gitsigns.nvim" 
  },
  cmd = "G", -- lazy load on :G command
  config = function()
    local fn = vim.fn
    local group = vim.api.nvim_create_augroup("NoeszcGitConfig", { clear = true })

    -- --- auto-populate commit message with branch name
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "gitcommit",
      callback = function()
        local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1]

        -- skip if it's a merge commit
        if content ~= "" and type(content:find "^Merge branch") ~= "nil" then
          return
        end

        -- extract ticket pattern (e.g., ABC-123) from branch name
        local branch = fn.system("git branch --show-current"):match "/?([%u%d]+-%d+)-?"

        if branch then
          vim.api.nvim_buf_set_lines(0, 0, -1, false, { branch .. " | " })
          vim.cmd ":startinsert!" -- focus at the end of the line
        end
      end,
      group = group,
    })

    -- --- sanitize git commands (replace spaces with dashes in branch names)
    vim.api.nvim_create_autocmd("CmdlineChanged", {
      callback = function()
        if vim.fn.getcmdtype() ~= ":" then
          return
        end

        local line = vim.fn.getcmdline()
        -- matches ':Git co ', ':Git br ', etc.
        local start, _end = line:find "^Gi?t? c[bo] "

        if start ~= nil then
          local prefix = line:sub(start, _end)
          local sufix = line:sub(_end + 1):gsub(" ", "-")
          local position = vim.fn.getcmdpos()

          vim.fn.setcmdline(prefix .. sufix, position)
        end
      end,
      group = group,
    })

    -- --- plugin setups
    require("gitsigns").setup()

    require("git-conflict").setup({
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })
  end,
}
