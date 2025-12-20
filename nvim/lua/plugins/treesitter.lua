return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPre",
  main = "nvim-treesitter.configs",
  opts = {
    -- list of parsers to install
    ensure_installed = {
      "typescript",
      "javascript",
      "tsx",
      "css",
      "html",
      "json",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "comment",
      "jsdoc",
    },
    sync_install = false,
    auto_install = true, -- automatically install missing parsers when entering a buffer
    highlight = {
      enable = true,
      -- disable highlighting for large files to maintain performance
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
  },
}
