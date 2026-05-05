--[[
  Path: lua/config/plugins/mini_icons.lua
  Module: config.plugins.mini_icons

  Purpose
    Lazy spec for mini.icons: consistent glyphs/highlights for special filenames
    (e.g. `.go-version`) and filetypes like `gotmpl`.

  Rationale
    Complements web-devicons and Treesitter; keeps icon tweaks in one small
    table instead of scattering `nvim_set_hl` calls.

  See `:help mini.icons`.
]]

---@type LazySpec
return {
{
  'nvim-mini/mini.icons',
  opts = {
    file = {
      ['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
    },
    filetype = {
      gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
    },
  },
},
}
