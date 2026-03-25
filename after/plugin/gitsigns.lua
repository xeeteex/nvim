local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#587c0c" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#0c7d9d" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f14c4c" })
vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#587c0c" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#0c7d9d" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#f14c4c" })
vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#1f2a12" })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#102a34" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#3b1212" })

gitsigns.setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
  preview_config = {
    border = "rounded",
    style = "minimal",
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
    end

    map("n", "]h", gs.next_hunk, "Next git hunk")
    map("n", "[h", gs.prev_hunk, "Previous git hunk")
    map("n", "<leader>hp", gs.preview_hunk, "Preview git hunk")
    map("n", "<leader>hs", gs.stage_hunk, "Stage git hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset git hunk")
    map("n", "<leader>hb", gs.toggle_current_line_blame, "Toggle git blame")
  end,
})
