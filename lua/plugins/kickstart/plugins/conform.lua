--[[
  Path: lua/plugins/kickstart/plugins/conform.lua
  Module: plugins.kickstart.plugins.conform

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
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {
        c = true,
        cpp = true,
        typescript = true,
        typescriptreact = true,
        javascript = true,
        javascriptreact = true,
        python = true,
        sql = true,
        json = true,
      }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return nil
      end
    end,
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
