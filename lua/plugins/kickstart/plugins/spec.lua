--[[
  Path: lua/plugins/kickstart/plugins/spec.lua
  Module: plugins.kickstart.plugins.spec

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
  'plugins.kickstart.plugins.guess_indent',
  'plugins.kickstart.plugins.gitsigns',
  'plugins.kickstart.plugins.which_key',
  'plugins.kickstart.plugins.render_markdown',
  'plugins.kickstart.plugins.telescope',
  'plugins.kickstart.plugins.lsp',
  'plugins.kickstart.plugins.conform',
  'plugins.kickstart.plugins.blink',
  'plugins.kickstart.plugins.tokyonight',
  'plugins.kickstart.plugins.todo_comments',
  'plugins.kickstart.plugins.mini',
  'plugins.kickstart.plugins.treesitter',
  'plugins.kickstart.plugins.vim_helm',
  'plugins.kickstart.plugins.neotest_golang',
  'plugins.kickstart.plugins.mini_icons',
  'plugins.kickstart.plugins.debug',
  'plugins.kickstart.plugins.indent_line',
  'plugins.kickstart.plugins.lint',
  'plugins.kickstart.plugins.autopairs',
  'plugins.kickstart.plugins.neo-tree',
  'custom.plugins',
}

for _, mod in ipairs(mods) do
  append_specs(specs, require(mod))
end

return specs
