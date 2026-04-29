-- Converted from lightline.vim
vim.o.laststatus = 2

vim.g.lightline = {
  colorscheme = 'onedark',
  active = {
    left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } },
    right = { { 'lineinfo' }, { 'fileformat', 'fileencoding', 'filetype' } },
  },
  component_function = {
    gitbranch = 'FugitiveHead',
    filename = 'LightlineFilename',
  },
}

vim.cmd([[
function! LightlineFilename()
  return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction
]])
