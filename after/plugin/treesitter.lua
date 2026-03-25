local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

pcall(vim.treesitter.language.register, "tsx", "javascriptreact")
pcall(vim.treesitter.language.register, "tsx", "typescriptreact")

configs.setup {
  ensure_installed = {
    "bash",
    "c",
    "css",
    "dockerfile",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },
}
