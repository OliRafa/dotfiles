return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
  {
    'mfussenegger/nvim-ansible',
    ft = {},
    keys = {
      {
        '<leader>ar',
        function()
          require('ansible').run()
        end,
        desc = 'Ansible Run Playbook/Role',
        silent = true,
      },
    },
  },
}
