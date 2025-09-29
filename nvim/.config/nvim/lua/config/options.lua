local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.cursorline = false
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.laststatus = 2
opt.termguicolors = true

-- Files
opt.undofile = true

-- Clipboard
opt.clipboard = "unnamedplus"

