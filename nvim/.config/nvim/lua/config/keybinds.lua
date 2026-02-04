vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', '<leader>r', ':update<CR>S :source<CR>', { noremap = true, silent = true }) --refresh config
map('n', '<leader>q', ':update<CR>S :quit<CR>', { noremap = true, silent = true })   --exit
