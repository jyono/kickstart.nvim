--[[
  Path: lua/config/plugins/toggleterm.lua
  Module: config.plugins.toggleterm

  Purpose
    Lazy spec for akinsho/toggleterm.nvim: floating terminal and the `:ToggleTerm`
    command used by `<leader>tf` in `config.keymaps`.

  Rationale
    Keymaps referenced ToggleTerm without a plugin; this wires the dependency.
    Floating keeps the editor context visible; change `direction` if you prefer split.

  See https://github.com/akinsho/toggleterm.nvim
]]

---@type LazySpec
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      direction = 'float',
      float_opts = { border = 'rounded' },
    },
  },
}
