--[[
  Path: lua/config/plugins/neo-tree.lua
  Module: config.plugins.neo-tree

  Purpose
    Lazy spec for nvim-neo-tree/neo-tree.nvim: filesystem sidebar, reveal/toggle
    keymaps, and tuned `filesystem` options (hidden files, libuv watcher, root).

  Rationale
    Centralizes file-tree UX; `<leader>x` / `<leader>z` maps live in keymaps.lua.
    Neo-tree spec lives alongside other Lazy modules under `config.plugins`.

  See https://github.com/nvim-neo-tree/neo-tree.nvim
]]

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
