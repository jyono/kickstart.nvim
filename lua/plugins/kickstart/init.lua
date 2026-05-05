--[[
  Path: lua/plugins/kickstart/init.lua
  Module: plugins.kickstart

  Purpose
    Orchestrates core editor setup: globals, options, keymaps, autocommands,
    diagnostics, then installs and loads third-party plugins via lazy.nvim.

  Load order
    1. Leader keys and UI flags must be set before lazy.nvim (plugin keymaps).
    2. Options, keymaps, autocommands, and diagnostics run before plugins so
       baseline behavior exists even if a plugin fails to load.
    3. `lazy.lua` runs last and pulls in the full Lazy plugin spec list.

  See `:help mapleader`, `:help vim.g`, `:help lazy.nvim.txt`.
]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

require 'plugins.kickstart.options'
require 'plugins.kickstart.keymaps'
require 'plugins.kickstart.autocmds'
require 'plugins.kickstart.diagnostics'
require 'plugins.kickstart.lazy'
