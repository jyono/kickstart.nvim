-- Neo-tree: https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      filesystem = {
        visible = false,
        window = {
          use_libuv_file_watcher = true,
          mappings = {
            ['\\'] = 'close_window',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
          },
        },
      },
    },
  },
}
