vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4         -- A tab is displayed as 4 spaces
vim.opt.shiftwidth = 4      -- Indentation uses 4 spaces
vim.opt.softtabstop = 4     -- Editing treats tab as 4 spaces
vim.opt.expandtab = true    -- Use spaces instead of tabs
vim.opt.smartindent = true  -- Smart autoindenting on new lines
vim.opt.autoindent = true  
vim.opt.cursorline = true   -- Highlight the current line

vim.opt.number = true       -- Show line numbers

vim.opt.wrap = false

vim.opt.ignorecase = true   -- Case-insensitive searching
vim.opt.smartcase = true
vim.opt.termguicolors = true 

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "80"

vim.opt.updatetime = 50
