--[[
  Path: init.lua (Neovim config root)
  Module: none — Neovim executes this file before any Lua `require`.

  Purpose
    Single entrypoint for your configuration. All Lua modules live under
    `lua/config/` (options, keymaps, lazy.nvim, plugin specs, utilities).

  Rationale
    A minimal root `init.lua` avoids duplicating logic that belongs in modular
    Lua modules and matches common Neovim + lazy.nvim layouts.

  See `:help config` and `:help lua-require`.
]]

require 'config'
