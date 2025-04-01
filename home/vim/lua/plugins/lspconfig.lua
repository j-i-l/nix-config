return {
  "neovim/nvim-lspconfig",
  config = function ()
    -- require('lspconfig').pyright.setup({
    --   settings = {
    --     python = {
    --       analysis = {
    --         typeCheckingMode = 'basic',
    --         -- Ignore all files for analysis to exclusively use Ruff for linting
    --         -- ignore = { '*' },
    --       },
    --     },
    --     pyright = {
    --       -- Using Ruff's import organizer
    --       disableOrganizeImports = true,
    --       inlayHints = {
    --         variableTypes = false,
    --         functionReturnTypes = false,
    --         parameterTypes = false,
    --         typeParameterTypes = false,
    --       }
    --     },
    --   },
    -- })
    require('lspconfig').ruff.setup({
      init_options = {
        settings = {
          lineLength = 80,
          fix = true,
        }
      }
    })
  end,
}
