---@type LazySpec
return {
{
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
  ft = { 'markdown', 'markdown.mdx' },
  opts = {
    latex = { enabled = false },
    completions = { lsp = { enabled = true }, blink = { enabled = true } },
  },
},
}
