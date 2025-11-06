return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff = {
          cmd_env = { RUFF_TRACE = 'messages' },
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
              },
            },
          },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    lazy = true,
    config = function()
      require('dap-python').setup 'python'
    end,
    keys = {
      {
        '<leader>Dtf',
        function()
          require('dap-python').test_method()
        end,
        desc = 'Debug: Test Function',
      },
      {
        '<leader>Dtc',
        function()
          require('dap-python').test_class()
        end,
        desc = 'Debug: Test Class',
      },
    },
  },
}
