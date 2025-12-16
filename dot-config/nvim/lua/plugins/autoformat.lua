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
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
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
          args = { 'format', '--dialect=databricks', '-' },
          stdin = true,
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
