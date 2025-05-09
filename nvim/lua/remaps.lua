-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show disgnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line Up' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line Down' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Appends the line bellow to the current line with a space' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half-page jumping down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half-page jumping up' })

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Preserve screen center while jumping to next searched word' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Preserve screen center while jumping to next searched word' })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without replacing buffer' })

vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank to end of line to system clipboard' })

vim.keymap.set('n', '<leader>fr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Find and replace word' })

-- Rails
vim.keymap.set('n', '<C-d>', function()
  require('toggleterm').exec_command "cmd='BINDING=0.0.0.0 bin/dev'"
end, { desc = 'Run Rails server binding to 0.0.0.0' })
