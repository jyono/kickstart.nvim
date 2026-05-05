--[[
  Path: lua/config/plugins/which_key.lua
  Module: config.plugins.which_key

  Purpose
    Lazy spec for which-key.nvim: discoverable pop-up of pending key sequences
    and group labels for `<leader>` chains (search, toggle, git hunks, LSP).

  Rationale
    Loaded on `VimEnter` so it does not delay first screen paint. `spec` entries
    document chains used elsewhere (Telescope, gitsigns, LSP maps).

  See `:help which-key.nvim.txt`.
]]

---@type LazySpec
return {
{ -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter',
  ---@module 'which-key'
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>ti', desc = 'LSP inlay hints', mode = { 'n' } },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  },
},
}
