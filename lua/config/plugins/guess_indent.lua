--[[
  Path: lua/config/plugins/guess_indent.lua
  Module: config.plugins.guess_indent

  Purpose
    Lazy spec for guess-indent.nvim: detects indentation style per buffer so new
    lines match tabs vs. spaces without manual `:set sw=`.

  Rationale
    Lightweight, runs early in the spec list; no keymaps. Keeps indent behavior
    consistent before Treesitter or LSP attach.

  See plugin README; `:help 'shiftwidth'`.
]]

---@type LazySpec
return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
}
