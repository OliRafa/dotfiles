return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        sql = { 'sqlfluff' },
      }
      -- When false, sqlfluff is silenced: no on-screen diagnostics and no
      -- fix-on-save (see the format_on_save gate in autoformat.lua). Handy for
      -- legacy SQL full of pre-existing inconsistencies that would otherwise
      -- clutter the buffer. Other linters keep running as usual.
      vim.g.sqlfluff_enabled = true

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.g.sqlfluff_enabled == false and vim.bo.filetype == 'sql' then
            return
          end
          lint.try_lint()
        end,
      })
      vim.keymap.set('n', '<leader>l', function()
        lint.try_lint()
      end, { desc = 'Trigger [l]inting for current file' })

      vim.keymap.set('n', '<leader>L', function()
        vim.g.sqlfluff_enabled = not vim.g.sqlfluff_enabled
        if vim.g.sqlfluff_enabled then
          lint.try_lint 'sqlfluff'
          vim.notify('sqlfluff: ON (lint + fix-on-save)', vim.log.levels.INFO)
        else
          -- Clear already-published sqlfluff diagnostics from every buffer.
          vim.diagnostic.reset(lint.get_namespace 'sqlfluff')
          vim.notify('sqlfluff: OFF (lint + fix-on-save)', vim.log.levels.INFO)
        end
      end, { desc = 'Toggle sqlfluff [L]int + fix-on-save' })

      lint.linters.sqlfluff.args = { 'lint', '--format=json', '--dialect=databricks', '-' }
      lint.linters.markdownlint.args = { '--stdin', '--disable', 'MD033', '--' }
    end,
  },
}
