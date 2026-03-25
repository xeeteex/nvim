if vim.fn.exists(":Git") == 0 then
  return
end

local function git(cmd)
  return function()
    vim.cmd(cmd)
  end
end

vim.keymap.set("n", "<leader>gs", git("Git"), { desc = "Git status", silent = true })
vim.keymap.set("n", "<leader>gd", git("Gdiffsplit"), { desc = "Git diff split", silent = true })
vim.keymap.set("n", "<leader>gb", git("Git blame"), { desc = "Git blame", silent = true })
vim.keymap.set("n", "<leader>gc", git("Git commit"), { desc = "Git commit", silent = true })
vim.keymap.set("n", "<leader>gp", git("Git push"), { desc = "Git push", silent = true })
vim.keymap.set("n", "<leader>gl", git("Git pull"), { desc = "Git pull", silent = true })
vim.keymap.set("n", "<leader>gw", git("Gwrite"), { desc = "Git stage current file", silent = true })
vim.keymap.set("n", "<leader>gr", git("Gread"), { desc = "Git reset current file", silent = true })
