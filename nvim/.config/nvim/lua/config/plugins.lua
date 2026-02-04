-- Plugin installer translated from plugins.vim
local fn = vim.fn
local split = vim.split
local data_dir = fn.stdpath('data') .. '/plugged'

local function ensure(repo)
    local parts = split(repo, '/')
    local name = parts[#parts]
    local path = data_dir .. '/' .. name
    if fn.isdirectory(path) == 0 then
        if fn.isdirectory(data_dir) == 0 then
            fn.mkdir(data_dir, 'p')
        end
        fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/' .. repo, path })
    end
    vim.opt.rtp:append(path)
end

ensure('joshdick/onedark.vim')
ensure('itchyny/lightline.vim')
