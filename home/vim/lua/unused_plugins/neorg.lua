return {
  "nvim-neorg/neorg",
  opts = {
      load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
              config = {
                  workspaces = {
                      notes = "~/notes",
                  },
                  default_workspace = "notes",
              },
          },
      },
  },
  dependencies = {
      { "nvim-lua/plenary.nvim", },
      { "vhyrro/luarocks.nvim", },
  },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
      },
    })
  end,
}
