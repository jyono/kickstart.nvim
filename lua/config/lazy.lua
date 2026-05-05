--[[
  Path: lua/config/lazy.lua
  Module: config.lazy

  Purpose
    Bootstraps folke/lazy.nvim if missing, prepends it to runtimepath, and calls
    `lazy.setup()` with the aggregated plugin specification plus UI icon prefs.

  Rationale
    lazy.nvim must be on `runtimepath` before `require('lazy')`. Keeping clone +
    setup here isolates plugin-manager mechanics from editor options/keymaps.

  See `:help lazy.nvim.txt`, `:help rtp`.
]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup(require 'config.plugins.spec', {
  -- No luarocks/hererocks: avoids :checkhealth lazy ERROR when hererocks is missing.
  -- Re-enable if you install a plugin that requires luarocks (:help lazy.nvim-rocks).
  rocks = { enabled = false },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
