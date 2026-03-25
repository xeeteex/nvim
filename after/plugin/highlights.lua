vim.opt.termguicolors = true

local ok, highlight_colors = pcall(require, "nvim-highlight-colors")
if not ok then
  return
end

highlight_colors.setup({})
