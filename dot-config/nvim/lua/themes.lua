-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'VonHeikemen/little-wonder',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.cmd.colorscheme 'lw-mariana'
    end,
  },
}
