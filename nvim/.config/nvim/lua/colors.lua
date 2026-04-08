local function load_term_colors()
    local colors = {}
    for line in io.lines(os.getenv("HOME") .. "/.config/ghostty/config") do
        local key, value = line:match("(%S+)%s*=%s*(#%x+)")
        if key and value then
            colors[key] = value
        end
    end
    return colors
end

local c = load_term_colors()

vim.api.nvim_set_hl(0, "Normal", {
    fg = c.foreground,
    bg = c.background,
})
