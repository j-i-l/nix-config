return {
  "neovim/nvim-lspconfig",
  config = function ()
    require('lspconfig').pyright.setup({
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            -- ignore = { '*' },
          },
        },
      },
    })
    require('lspconfig').ruff.setup({
      init_options = {
        settings = {
          lineLength = 80
        }
      }
    })
  end,
}
