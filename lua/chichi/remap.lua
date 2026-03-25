local opts = { silent = true }

vim.keymap.set("n", "<leader>q", vim.cmd.Ex, { desc = "Open netrw", silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line and keep cursor centered", silent = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down centered", silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up centered", silent = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered", silent = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered", silent = true })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without yanking", silent = true })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode", silent = true })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard", silent = true })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank selection to system clipboard", silent = true })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank line to system clipboard", silent = true })

vim.keymap.set("v", "<", "<gv", vim.tbl_extend("force", opts, { desc = "Indent left and keep selection" }))
vim.keymap.set("v", ">", ">gv", vim.tbl_extend("force", opts, { desc = "Indent right and keep selection" }))

vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights", silent = true })
