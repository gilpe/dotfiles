local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Unselect Find results
-- map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Quick save and quick close
-- map("n", "<leader>w", ":w<CR>", opts)
-- map("n", "<leader>q", ":q<CR>", opts)

-- Better pane navigation
map("n", "<C-Left>", "<C-w>h", opts)
map("n", "<C-Down>", "<C-w>j", opts)
map("n", "<C-Up>", "<C-w>k", opts)
map("n", "<C-Right>", "<C-w>l", opts)

-- Splits resize
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Visual mode line movement
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Centered cursor on Find
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Paste over selection without losing the register
map("x", "<leader>p", [["_dP]], opts)

-- Copy to clipboard
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)

-- Delete blank record
map({ "n", "v" }, "<leader>d", [["_d]], opts)

-- Better buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
