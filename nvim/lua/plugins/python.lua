return {
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
}
