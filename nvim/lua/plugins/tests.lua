return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'jfpedroza/neotest-elixir',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-elixir' {
            args = { '--trace' },
          },
          require 'neotest-python' {
            dap = { justMyCode = false },
            pytest_discover_instances = true,
            runner = 'pytest',
          },
        },
      }
    end,
    keys = {
      { '<leader>t', '', desc = '+test' },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run All Tests in File',
      },
      {
        '<leader>ta',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Run All Test',
      },
      {
        '<leader>tc',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run Test Case',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last Test',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Summary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = 'Show Output',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle Output Panel',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop',
      },
      {
        '<leader>tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = 'Toggle Watch',
      },
    },
  },
}
