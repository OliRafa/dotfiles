return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
          },
        },
      }
    end,
    keys = {
      { '<leader>tf', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = 'Run tests in file' },
      { '<leader>tc', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Run test case' },
      { '<leader>td', "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = 'Run debugger in test case' },
    },
  },
}
