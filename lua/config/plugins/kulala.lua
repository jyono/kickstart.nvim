--[[
  Path: lua/config/plugins/kulala.lua
  Module: config.plugins.kulala

  Purpose
    Lazy spec for kulala.nvim: HTTP / REST client from the editor.

  See https://github.com/mistweaverco/kulala.nvim
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
