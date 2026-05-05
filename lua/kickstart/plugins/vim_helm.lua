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
