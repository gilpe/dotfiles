return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add tsx and treesitter
    vim.list_extend(opts.ensure_installed, {
      "c_sharp",
      "gdscript",
      "godot_resource",
      "toml",
      "sql",
      "json",
      "yaml",
      "xml",
      "markdown",
    })
  end,
}
