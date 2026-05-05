--[[
  Path: lua/config/git_links.lua
  Module: config.git_links

  Purpose
    Opens the current buffer’s file on GitHub (or compatible origin) in the
    browser, including a line or range anchor from Normal or Visual mode.

  Rationale
    Used by `config.keymaps` (`<leader>go`).

  Dependencies: git(1); `vim.ui.open` on Nvim 0.10+, else `open` / `xdg-open` / `cmd start`.
]]

local M = {}

---@param url string
local function open_url(url)
  if vim.ui and vim.ui.open then
    vim.ui.open(url)
    return
  end
  local cmd
  if vim.fn.has 'win32' == 1 then
    cmd = { 'cmd', '/c', 'start', '', url }
  elseif vim.fn.has 'macunix' == 1 then
    cmd = { 'open', url }
  else
    cmd = { 'xdg-open', url }
  end
  vim.fn.jobstart(cmd, { detach = true })
end

M.open_github = function()
  local file_path = vim.fn.systemlist('git ls-files --full-name ' .. vim.fn.expand '%')[1]
  if not file_path or file_path == '' then
    print 'File not tracked by git.'
    return
  end

  local remote = vim.fn.system('git config --get remote.origin.url'):gsub('\n', ''):gsub('%.git$', '')
  if remote:match '^git@' then
    remote = remote:gsub(':', '/'):gsub('git@', 'https://')
  end

  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')

  local line_start = vim.fn.line 'v'
  local line_end = vim.fn.line '.'
  if line_start > line_end then
    line_start, line_end = line_end, line_start
  end

  local line_anchor = 'L' .. line_end
  if vim.fn.mode():match '[vV]' then
    line_anchor = 'L' .. line_start .. '-L' .. line_end
  end

  local url = string.format('%s/blob/%s/%s#%s', remote, branch, file_path, line_anchor)
  open_url(url)
  print 'Opened in GitHub'
end

return M
