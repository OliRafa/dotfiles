return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      server = {
        root_dir = function(fname)
          return vim.fn.getcwd()
        end,
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'tailwind-tools',
      { 'roobert/tailwindcss-colorizer-cmp.nvim', opts = {} },
    },
    opts = function(_, opts)
      opts.formatting = {
        format = require('tailwindcss-colorizer-cmp').formatter,
      }
    end,
  },
}
