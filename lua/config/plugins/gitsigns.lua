--[[
  Path: lua/config/plugins/gitsigns.lua
  Module: config.plugins.gitsigns

  Purpose
    Lazy spec for lewis6991/gitsigns.nvim: gutter hunks, stage/reset, blame,
    diff against index / HEAD / default branch, and buffer-local keymaps.

  Rationale
    Single source of truth for Git-in-editor UX; pairs with which-key groups
    under `<leader>h` and avoids duplicating gitsigns setup in `init.lua`.

  See `:help gitsigns`.
]]

---@type LazySpec
return {
{ -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  ---@module 'gitsigns'
  ---@type Gitsigns.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Detect branch once per buffer attach
      local primary_branch = 'main'
      local handle = io.popen 'git branch --list main master'
      if handle then
        local result = handle:read '*a'
        handle:close()
        if not string.find(result, 'main') and string.find(result, 'master') then
          primary_branch = 'master'
        end
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [s]tage hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [r]eset hunk' })

      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hB', gitsigns.blame, { desc = 'git [B]lame toggle' })

      -- Diff Mappings
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })

      map('n', '<leader>hm', function()
        gitsigns.diffthis(primary_branch)
      end, { desc = 'git diff against [m]ain/master' })

      -- Toggles
      map('n', '<leader>ht', gitsigns.toggle_current_line_blame, { desc = '[t]oggle git show blame line' })
      map('n', '<leader>hv', gitsigns.preview_hunk_inline, { desc = 'toggle git show deleted ([v]iew)' })
    end,
  },
},
}
