return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', function()
      vim.cmd 'topleft Git'
    end, { desc = '[G]it [S]atus' })
    vim.keymap.set('n', '<leader>gc', function()
      vim.cmd 'topleft Git commit'
    end, { desc = '[G]it [C]ommit' })
    vim.keymap.set('n', '<leader>gh', function()
      vim.cmd 'vert abo Git log -- %'
      vim.cmd 'vertical resize 60'
    end, { desc = '[G]it File [H]istory' })
  end,
}
