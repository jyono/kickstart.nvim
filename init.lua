--[[
  Path: init.lua (Neovim config root)
  Module: none — Neovim executes this file before any Lua `require`.

  Purpose
    Single entrypoint for your configuration. Everything else lives under
    `lua/` so this file stays small and easy to skim.

  Rationale
    A minimal root `init.lua` avoids duplicating logic that belongs in modular
    Lua modules and matches common Neovim + lazy.nvim layouts.

  See `:help config` and `:help lua-require`.
]]

require 'plugins.kickstart'
