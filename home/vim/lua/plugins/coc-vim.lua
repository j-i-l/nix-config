return {
  "neoclide/coc.nvim",
  branch = "release",
  config = function()
            -- CoC configuration
            vim.g.coc_global_extensions = {
                'coc-json',  -- JSON support
                'coc-pyright',  -- Python support
                'coc-tsserver',  -- TypeScript/JavaScript support
                -- Add more extensions as needed
            }

            -- Additional settings
            -- TODO: Seems not to work
            vim.cmd [[
                " Enable auto-completion
                set completeopt=menuone,noinsert,noselect

                " Use <Tab> and <S-Tab> to navigate through popup menu
                inoremap <silent><expr> <Tab> coc#pum#visible() ? "\<C-n>" : "\<Tab>"
                inoremap <silent><expr> <S-Tab> coc#pum#visible() ? "\<C-p>" : "\<S-Tab>"
            ]]
  end,
  opts = {
    -- General settings for CoC
    autoSuggest = true, -- Enable auto-suggestions
    completion = {
      enable = true, -- Enable completion
      autoTrigger = true, -- Automatically trigger completion
    },
    diagnostics = {
      enable = true, -- Enable diagnostics
      underline = true, -- Underline errors and warnings
      virtualText = true, -- Show virtual text for diagnostics
    },
    -- You can add more settings as needed
    -- Example of language server settings
    languages = {
      python = {
        command = "pyright",
        args = {},
        settings = {
          python = {
            analysis = {
              -- does not work:
              typeCheckingMode = "off", -- Disable type checking to avoid inline hints
            },
          },
        },
      },
      javascript = {
        command = "tsserver",
        args = {},
      },
    },
    -- Presets for easier configuration
    presets = {
      bottom_search = true, -- Use a classic bottom cmdline for search
      command_palette = true, -- Position the cmdline and popupmenu together
      long_message_to_split = true, -- Long messages will be sent to a split
      inc_rename = true, -- Enables an input dialog for renaming
      lsp_doc_border = true, -- Add a border to hover docs and signature help
    },
  },
}
