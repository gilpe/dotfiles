return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        explorer = {
            ---@class snacks.explorer.Config
            enabled = true,
            replace_netrw = true,
            hidden = true,
        },
    },
    keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    }
}
