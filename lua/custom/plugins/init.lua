-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'mistweaverco/kulala.nvim',
    keys = {
      { '<leader>Rs', desc = 'Send request' },
      { '<leader>Ra', desc = 'Send all requests' },
      { '<leader>Rb', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    opts = {
      -- your configuration comes here
      global_keymaps = false,
      global_keymaps_prefix = '<leader>R',
      kulala_keymaps_prefix = '',
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    opts = {
      filesystem = {
        visible = false,
        window = {
          mappings = {
            ['.'] = 'set_root', -- Set current directory as root
            ['H'] = 'toggle_hidden', -- Toggle hidden files with 'H'
          },
        },
      },
    },
  },
}
