--[[
  Path: lua/config/plugins/todo_comments.lua
  Module: config.plugins.todo_comments

  Purpose
    Lazy spec for todo-comments.nvim: highlights TODO/FIXME/HACK-style comment
    tokens and can integrate with Telescope (optional).

  Rationale
    Purely visual aid for scanning large codebases; `signs = false` avoids
    gutter clutter if you prefer highlight-only.

  See https://github.com/folke/todo-comments.nvim
]]

---@type LazySpec
return {
{
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ---@module 'todo-comments'
  ---@type TodoOptions
  ---@diagnostic disable-next-line: missing-fields
  opts = { signs = false },
},
}
