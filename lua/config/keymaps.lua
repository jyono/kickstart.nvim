--[[
  Path: lua/config/keymaps.lua
  Module: config.keymaps

  Purpose
    Non-plugin (or minimally coupled) normal-mode maps: search, diagnostics
    quickfix, terminal escape, window navigation, GitHub “open in browser,”
    Neo-tree toggles, and visual paste without clobbering a register.

  Rationale
    Keeping these maps here avoids scattering `vim.keymap.set` across plugin
    config files and ensures they exist even before lazy.nvim finishes loading.

  See `:help vim.keymap.set()`, `:help diagnostic-loclist`.
]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>th', ':split | terminal<CR>', { desc = 'Terminal horizontal split' })
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { desc = 'Terminal vertical split' })
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Terminal in new tab' })
vim.keymap.set('n', '<leader>tf', ':ToggleTerm<CR>', { desc = 'Toggle floating terminal' })

vim.keymap.set('x', 'p', '"_dP', { noremap = true, silent = true })

local git_links = require 'config.git_links'
vim.keymap.set({ 'n', 'v' }, '<leader>go', git_links.open_github, { desc = 'Open in GitHub' })

vim.keymap.set('n', '<leader>x', '<cmd>Neotree toggle<cr>', { desc = 'NeoTree Toggle' })
vim.keymap.set('n', '<leader>z', '<cmd>Neotree reveal<cr>', { desc = 'NeoTree Reveal' })
