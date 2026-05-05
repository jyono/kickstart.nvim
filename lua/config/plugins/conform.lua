--[[
  Path: lua/config/plugins/conform.lua
  Module: config.plugins.conform

  Purpose
    Lazy spec for conform.nvim: formatter orchestration (`<leader>f`), per-FT
    formatter lists (stylua, sql_formatter, prettier), and format-on-save policy.

  Rationale
    Keeps formatting separate from LSP where you explicitly disable or gate LSP
    format fallback per filetype.

  See `:help conform.nvim`.
]]

---@type LazySpec
return {
{ -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    -- Explicit: no format-on-save (use `<leader>f` manually). Previously a
    -- `format_on_save` function always returned nil with dead branch logic.
    format_on_save = false,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      lua = { 'stylua' },
      sql = { 'sql_formatter' },
      json = { 'prettier' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      ['sql_formatter'] = {
        prepend_args = { '-l', 'postgresql', '-c', '{"useTabs": true}' },
      },
    },
  },
},
}
