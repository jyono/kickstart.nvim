--[[
  Path: lua/plugins/kickstart/options.lua
  Module: plugins.kickstart.options

  Purpose
    Sets buffer-agnostic Neovim options (`vim.o` / `vim.opt`): editing feel,
    UI chrome, search, splits, and persistence (e.g. undofile).

  Rationale
    Centralizing options keeps behavior predictable and documents defaults in
    one place. Clipboard is scheduled after UI enter to avoid slowing startup.

  See `:help vim.o`, `:help option-list`, `:help 'clipboard'`.
]]

vim.o.number = true

vim.o.mouse = 'a'

vim.o.showmode = false

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.confirm = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.autoread = true
