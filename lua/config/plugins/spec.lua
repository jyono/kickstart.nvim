--[[
  Path: lua/config/plugins/spec.lua
  Module: config.plugins.spec

  Purpose
    Builds the complete lazy.nvim plugin list: requires each per-plugin module,
    normalizes return shapes (single spec vs. `{ spec }`), and returns one flat
    `LazySpec` array for `lazy.setup()`.

  Rationale
    Splitting each plugin into its own file keeps diffs small and matches how
    lazy.nvim expects multiple tables to be merged at setup time.

  See `:help lazy.nvim-plugin-spec`, `:help LazySpec`.
]]

---@param out table
---@param chunk LazySpec|LazySpec[]
local function append_specs(out, chunk)
  if type(chunk[1]) == 'string' then
    out[#out + 1] = chunk
    return
  end
  for i = 1, #chunk do
    out[#out + 1] = chunk[i]
  end
end

---@type LazySpec
local specs = {}
local mods = {
  'config.plugins.guess_indent',
  'config.plugins.gitsigns',
  'config.plugins.which_key',
  'config.plugins.render_markdown',
  'config.plugins.telescope',
  'config.plugins.lsp',
  'config.plugins.conform',
  'config.plugins.blink',
  'config.plugins.tokyonight',
  'config.plugins.todo_comments',
  'config.plugins.mini',
  'config.plugins.treesitter',
  'config.plugins.vim_helm',
  'config.plugins.toggleterm',
  'config.plugins.mini_icons',
  'config.plugins.debug',
  'config.plugins.indent_line',
  'config.plugins.lint',
  'config.plugins.autopairs',
  'config.plugins.neo-tree',
  'config.plugins.kulala',
}

for _, mod in ipairs(mods) do
  append_specs(specs, require(mod))
end

return specs
