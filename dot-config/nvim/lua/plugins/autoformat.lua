return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        -- Respect the sqlfluff on/off toggle (<leader>L, defined in lint.lua):
        -- when it's off, skip auto-fixing SQL on save too, not just the
        -- on-screen diagnostics. Returning nil tells conform not to format.
        if vim.g.sqlfluff_enabled == false and (ft == 'sql' or ft == 'pgsql') then
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[ft] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters = {
        sqlfluff = {
          command = 'sqlfluff',
          -- `fix` applies every fixable rule that `lint` reports (e.g. AL03
          -- missing `AS`), whereas `format` only reflows layout/capitalisation.
          -- Using `fix` keeps what's fixed-on-save in sync with what the linter
          -- shows on screen.
          args = { 'fix', '--dialect=databricks', '-' },
          stdin = true,
          -- `sqlfluff fix` exits 1 when unfixable violations remain (or the SQL
          -- can't be parsed). It still writes the corrected SQL to stdout, so
          -- accept that exit code; on a parse error it echoes the input back
          -- unchanged, leaving the buffer intact.
          exit_codes = { 0, 1 },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'jq' },
        lua = { 'stylua' },
        markdown = { 'markdownlint' },
        pgsql = { 'sqlfluff' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        sql = { 'sqlfluff' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'yamlfix' },
      },
    },
  },
}
