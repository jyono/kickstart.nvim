--[[
  Path: lua/config/plugins/indent_line.lua
  Module: config.plugins.indent_line

  Purpose
    Lazy spec for indent-blankline.nvim (`ibl`): optional vertical guides aligned
    with indentation levels for readability in deeply nested code.

  Rationale
    Purely visual; lazy-loads via `main = 'ibl'`. Defaults are minimal; extend
    `opts` if you want scope rules or excluded filetypes.

  See `:help ibl.txt`.
]]

---@module 'lazy'
---@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = 'ibl',
  ---@module 'ibl'
  ---@type ibl.config
  opts = {},
}
