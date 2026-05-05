--[[
  Path: lua/config/plugins/telescope.lua
  Module: config.plugins.telescope

  Purpose
    Lazy spec for telescope.nvim: fuzzy finder for files, grep, diagnostics,
    git, help, and LSP pickers; includes fzf-native and ui-select extensions.

  Rationale
    Large `config` function registers `<leader>s*` maps and theme extensions.
    Deferred `require('telescope.builtin')` from LSP attach remains valid.

  See `:help telescope`, `:help telescope.setup()`.
]]

---@type LazySpec
return {
{ -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  -- By default, Telescope is included and acts as your picker for everything.

  -- If you would like to switch to a different picker (like snacks, or fzf-lua)
  -- you can disable the Telescope plugin by setting enabled to false and enable
  -- your replacement picker by requiring it explicitly in `config.plugins.spec`

  -- Note: If you customize your config for yourself,
  -- it’s best to remove the Telescope plugin config entirely
  -- instead of just disabling it here, to keep your config clean.
  enabled = true,
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function() return vim.fn.executable 'make' == 1 end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sD', function()
      local current_dir = vim.fn.expand '%:p:h' -- Gets the absolute path to the current file's folder
      require('telescope.builtin').diagnostics {
        cwd = current_dir,
        -- This ensures it searches within the directory, not just the file
        root_dir = current_dir,
      }
    end, { desc = '[S]earch [D]iagnostics in current directory' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- vim.keymap.set('n', '<leader>g', '', { desc = '[Git]' })
    -- vim.keymap.set('n', '<leader>gl', builtin.git_bcommits, { desc = '[Git] Buffer Commits' })
    -- vim.keymap.set('n', '<leader>gr', builtin.git_bcommits_range, { desc = '[Git] Buffer Commits Range' })
    -- vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[Git] Branches' })
    -- vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[Git] Commits' })
    -- vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[Git] Files' })
    -- vim.keymap.set('n', '<leader>gt', builtin.git_stash, { desc = '[Git] Stash' })
    -- vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[Git] Status' })
    -- vim.keymap.set('n', '<leader>gm', function()
    --   builtin.git_commits {
    --     git_command = { 'git', 'log', '--oneline', '--decorate', 'main..HEAD' },
    --   }
    -- end, { desc = '[Git] Commits ahead of main' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set(
      'n',
      '<leader>s/',
      function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      { desc = '[S]earch [/] in Open Files' }
    )

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    vim.keymap.set('n', '<leader>sag', function()
      builtin.live_grep {
        prompt_title = 'Live Grep (All Files)',
        -- This function adds the flags to the underlying grep command
        additional_args = function(args)
          return { '--hidden', '--no-ignore', '--no-ignore-parent', '--glob=!**/.git/*' }
        end,
      }
    end, { desc = '[S]earch [A]ll Files [G]rep)' })

    vim.keymap.set('n', '<leader>saf', function()
      builtin.find_files {
        prompt_title = 'Find All Files (Hidden + Ignored)',
        hidden = true, -- Show hidden dotfiles
        no_ignore = true, -- Ignore .gitignore rules
        no_ignore_parent = true, -- Ignore .gitignore rules of all parents, too
        file_ignore_patterns = { '.git/' }, -- <--- Explicitly remove the .git folder
      }
    end, { desc = '[S]earch [A]ll [F]iles' })
  end,
},
}
