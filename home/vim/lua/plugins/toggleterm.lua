return {
  'akinsho/toggleterm.nvim',
  config = function ()
    require("toggleterm").setup({
      open_mapping = [[<c-/>]],
      on_create = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_chan_send(term.job_id, "nix-shell\n")
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      direction='float'
    })
    -- Key mapping to toggle the terminal
    vim.api.nvim_set_keymap('v', '<S-C-/>', ':ToggleTermSendVisualSelection<CR>', { noremap = true, silent = true })
  end,
}
