--[[
  Path: lua/config/diagnostics.lua
  Module: config.diagnostics

  Purpose
    One global `vim.diagnostic.config` for how LSP diagnostics render: signs,
    virtual text, floating previews, underline, and sort order.

  Rationale
    A single module avoids conflicting `vim.diagnostic.config` calls (e.g. one
    at startup and another inside LSP setup) overwriting each other.

  See `:help vim.diagnostic.config()`, `:help diagnostic-signs`.
]]

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = true,
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}
