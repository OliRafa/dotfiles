return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.config', -- Sets main module to use for opts
    opts = {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    },
    config = function(_, opts)
      require('nvim-treesitter.config').setup(opts)

      -- ensure_installed is no longer handled by nvim-treesitter.config.setup(),
      -- so we install missing parsers explicitly.
      local ensure_installed = {
        'bash',
        'c',
        'diff',
        'elixir',
        'eex',
        'erlang',
        'heex',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }

      local installed = require('nvim-treesitter.config').get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, ensure_installed)

      if #missing > 0 then
        require('nvim-treesitter.install').install(missing)
      end
    end,
  },
}
