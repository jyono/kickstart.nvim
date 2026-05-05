--[[
  Path: lua/config/autocmds.lua
  Module: config.autocmds

  Purpose
    Small, global autocommand hooks: yank highlight feedback and safer defaults
    for Markdown buffers (modelines off in untrusted README-style files).

  Rationale
    Autocommands belong next to options/keymaps so “editor shell” behavior is
    grouped separately from per-plugin `config = function()` blocks.

  See `:help autocmd`, `:help vim.hl.on_yank()`, `:help 'modeline'`.
]]

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('config-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config-markdown-safe-read', { clear = true }),
  pattern = 'markdown',
  callback = function()
    vim.opt_local.modeline = false
  end,
})
