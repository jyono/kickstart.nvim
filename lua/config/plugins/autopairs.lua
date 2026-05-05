--[[
  Path: lua/config/plugins/autopairs.lua
  Module: config.plugins.autopairs

  Purpose
    Lazy spec for nvim-autopairs: inserts/closes paired brackets and quotes in
    Insert mode; integrates cleanly with completion when configured.

  Rationale
    Loaded on `InsertEnter` so startup stays fast. Empty `opts` uses plugin
    defaults; customize here if you need rule exceptions or cmp integration.

  See https://github.com/windwp/nvim-autopairs
]]

---@module 'lazy'
---@type LazySpec
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
}
