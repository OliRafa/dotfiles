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
    -- tailwindcss LSP is configured via the lspconfig spec above; keep
    -- tailwind-tools out of the LSP path so it doesn't call the deprecated
    -- `require('lspconfig')` framework.
    opts = {
      server = { override = false },
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = { tailwind = true },
    },
  },
}
