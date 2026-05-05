--[[
  Path: lua/custom/plugins/init.lua
  Module: custom.plugins

  Purpose
    Lazy.nvim specs for plugins that are not part of the main `config`
    tree (e.g. HTTP client, experimental additions).

  Rationale
    `config.plugins.spec` appends this module last so your personal
    plugins stay merge-friendly and easy to find. Neo-tree and core stack live
    under `config.plugins` instead.

  See `:help lazy.nvim-plugin-spec`.
]]

---@module 'lazy'
---@type LazySpec
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
      global_keymaps = false,
      global_keymaps_prefix = '<leader>R',
      kulala_keymaps_prefix = '',
    },
  },
}
