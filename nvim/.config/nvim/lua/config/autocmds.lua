local autocmd = vim.api.nvim_create_autocmd

-- Highligthing while copying
autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

-- Remove whitespaces while saving
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Restore prompt to the latest position while opening
autocmd("BufReadPost", {
  desc = "Go to last loc when opening a buffer",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, [["]])
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Update buffer when changes are made externally
autocmd({ "FocusGained", "BufEnter" }, {
  desc = "Reload file if changed outside",
  command = "checktime",
})

-- Autoformat on certain files
autocmd("FileType", {
  pattern = "gitcommit",
  command = "setlocal spell",
})
