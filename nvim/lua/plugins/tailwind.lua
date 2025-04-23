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
    opts = {},
  },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = { tailwind = true },
    },
  },
}
