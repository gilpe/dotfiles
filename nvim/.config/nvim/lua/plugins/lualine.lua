return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- iconos opcionales
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",       -- detecta automáticamente según tu esquema de colores
                    icons_enabled = true, -- activa iconos si tienes devicons
                    globalstatus = true,  -- una sola statusline para todas las ventanas
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } }, -- path=1 muestra ruta relativa
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
}
