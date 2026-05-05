--[[
  Path: lua/config/plugins/vim_helm.lua
  Module: config.plugins.vim_helm

  Purpose
    Lazy spec for towolf/vim-helm: sets `filetype=helm` on Helm templates so
    Treesitter/YAML tooling attach to the correct grammar instead of plain YAML.

  Rationale
    Small filetype shim; loaded on `BufReadPre` before heavy YAML LSP hooks run.

  See Helm tooling docs; plugin README.
]]

---@type LazySpec
return {
{
  'towolf/vim-helm',
  event = 'BufReadPre',
  config = function()
    -- This plugin automatically detects helm files (including .tpl)
    -- and sets the filetype to "helm" instead of "yaml"
  end,
},
}
