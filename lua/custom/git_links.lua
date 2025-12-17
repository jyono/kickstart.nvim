local M = {}

M.open_github = function()
  -- Get current file path relative to the git project root
  local file_path = vim.fn.systemlist('git ls-files --full-name ' .. vim.fn.expand '%')[1]
  if not file_path or file_path == '' then
    print 'File not tracked by git.'
    return
  end

  -- Get remote URL and clean it up (handles HTTPS and SSH)
  local remote = vim.fn.system('git config --get remote.origin.url'):gsub('\n', ''):gsub('%.git$', '')
  if remote:match '^git@' then
    remote = remote:gsub(':', '/'):gsub('git@', 'https://')
  end

  -- Get current branch
  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')

  -- Get line numbers (handles single line or visual selection)
  local line_start = vim.fn.line 'v'
  local line_end = vim.fn.line '.'
  if line_start > line_end then
    line_start, line_end = line_end, line_start
  end

  local line_anchor = 'L' .. line_end
  if vim.fn.mode():match '[vV]' then
    line_anchor = 'L' .. line_start .. '-L' .. line_end
  end

  -- Build and open the URL
  local url = string.format('%s/blob/%s/%s#%s', remote, branch, file_path, line_anchor)

  -- Linux only: using xdg-open in the background to avoid freezing Neovim
  vim.fn.jobstart({ 'xdg-open', url }, { detach = true })
  print 'Opened in GitHub'
end

return M
