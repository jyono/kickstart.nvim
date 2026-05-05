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
  'kickstart.plugins.guess_indent',
  'kickstart.plugins.gitsigns',
  'kickstart.plugins.which_key',
  'kickstart.plugins.render_markdown',
  'kickstart.plugins.telescope',
  'kickstart.plugins.lsp',
  'kickstart.plugins.conform',
  'kickstart.plugins.blink',
  'kickstart.plugins.tokyonight',
  'kickstart.plugins.todo_comments',
  'kickstart.plugins.mini',
  'kickstart.plugins.treesitter',
  'kickstart.plugins.vim_helm',
  'kickstart.plugins.neotest_golang',
  'kickstart.plugins.mini_icons',
  'kickstart.plugins.debug',
  'kickstart.plugins.indent_line',
  'kickstart.plugins.lint',
  'kickstart.plugins.autopairs',
  'kickstart.plugins.neo-tree',
  'custom.plugins',
}

for _, mod in ipairs(mods) do
  append_specs(specs, require(mod))
end

return specs
