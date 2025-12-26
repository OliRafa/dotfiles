return {
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    lazy = true,
    config = function()
      require('dap-python').setup 'debugpy-adapter'
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
