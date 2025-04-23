return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        elixirls = {},
      },
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lspconfig.elixirls.setup {
        cmd = { 'elixir-ls' },
        -- set default capabilities for cmp lsp completion source
        capabilities = capabilities,
      }
    end,
    keys = {
      { '<leader>fp', '<cmd>ElixirFromPipe<CR>', desc = 'Elixir: From Pipe' },
      { '<leader>tp', '<cmd>ElixirToPipe<CR>', desc = 'Elixir: To Pipe' },
      { '<leader>em', '<cmd>ElixirExpandMacro<CR>', desc = 'Elixir: Expand Macro' },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'elixir', 'heex', 'eex' })
      vim.treesitter.language.register('markdown', 'livebook')
    end,
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'jfpedroza/neotest-elixir',
    },
    opts = {
      adapters = {
        ['neotest-elixir'] = {},
      },
    },
  },
  {
    'nvimtools/none-ls.nvim',
    optional = true,
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.credo.with {
          condition = function(utils)
            return utils.root_has_file '.credo.exs'
          end,
        },
      })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = {
        elixir = { 'credo' },
      }

      opts.linters = {
        credo = {
          condition = function(ctx)
            return vim.fs.find({ '.credo.exs' }, { path = ctx.filename, upward = true })[1]
          end,
        },
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    optional = true,
    ft = function(_, ft)
      vim.list_extend(ft, { 'livebook' })
    end,
  },
  {
    'elixir-tools/elixir-tools.nvim',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local elixir = require 'elixir'
      local elixirls = require 'elixir.elixirls'

      elixir.setup {
        nextls = { enable = false },
        elixirls = { enable = false },
        projectionist = { enable = false },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
