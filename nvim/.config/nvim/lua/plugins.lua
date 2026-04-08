--Requires vim-plug. To install execute this:
--sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('jeffkreeftmeijer/vim-dim')  --theme
Plug('nvim-lualine/lualine.nvim') --statusline

vim.call('plug#end')

-- Color scheme
--vim.cmd('silent! colorscheme onedark')
