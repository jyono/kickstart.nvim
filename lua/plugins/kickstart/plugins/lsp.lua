--[[
  Path: lua/plugins/kickstart/plugins/lsp.lua
  Module: plugins.kickstart.plugins.lsp

  Purpose
    Lazy spec for nvim-lspconfig + Mason + blink.cmp integration: LspAttach
    keymaps, server table (clangd, gopls, pyright, rust, ts_ls, lua_ls, etc.),
    Mason tool installer, and 0.11 `vim.lsp.config` / `vim.lsp.enable` wiring.

  Rationale
    Concentrates all LSP lifecycle logic in one place. Blink is both a
    dependency (capabilities) and a top-level plugin spec in `blink.lua`.

  See `:help lsp`, `:help mason.nvim`, `:help blink.cmp`.
]]

---@type LazySpec
return {
{
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Load before this plugin's config runs so get_lsp_capabilities() exists even when
    -- LSP startup happens before VimEnter (e.g. `nvim file.py`).
    { 'saghen/blink.cmp', version = '1.*' },
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    {
      'mason-org/mason.nvim',
      ---@module 'mason.settings'
      ---@type MasonSettings
      ---@diagnostic disable-next-line: missing-fields
      opts = {},
    },
    -- Maps LSP server names between nvim-lspconfig and Mason package names.
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Defer requiring Telescope until keypress: on `nvim file.py`, LspAttach can run
        -- before VimEnter, when lazy.nvim has not loaded telescope.nvim yet.
        --
        -- Nvim 0.11+ sets *global* defaults grr/gri/grt/gO → vim.lsp.buf.* (quickfix / loclist).
        -- Buffer-local maps override. Match kickstart.nvim: grr gri grd gO gW grt (see telescope
        -- LspAttach in upstream). `grd` is not a core default — it was only in your fork/telescope.
        map('grr', function() require('telescope.builtin').lsp_references() end, '[R]eferences')
        map('gri', function() require('telescope.builtin').lsp_implementations() end, '[I]mplementation')
        map('grd', function() require('telescope.builtin').lsp_definitions() end, '[G]oto [D]efinition')
        map('gO', function() require('telescope.builtin').lsp_document_symbols() end, 'Open Document Symbols')
        map('gW', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 'Open Workspace Symbols')
        -- gopls may error on anonymous func types ("cannot find type name from type func(...)"):
        -- put the cursor on a named identifier, or use grd on the symbol name — same LSP limit.
        map('grt', function() require('telescope.builtin').lsp_type_definitions() end, '[G]oto [T]ype Definition')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- =========================================================================
        -- NEW: The gopls Semantic Tokens Workaround
        -- =========================================================================
        if client and client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          if semantic then
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end
        -- =========================================================================

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
      end,
    })


    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    ---@type table<string, vim.lsp.Config>
    local servers = {
      clangd = {},

      -- =========================================================================
      -- UPDATED: The unified "God Mode" gopls config
      -- =========================================================================
      gopls = {
        settings = {
          gopls = {
            buildFlags = {
              '-tags',
              'functional,integration,small,medium,large',
            },

            -- Completion settings
            completeUnimported = true,
            usePlaceholders = true,
            deepCompletion = true,
            matcher = 'Fuzzy',

            -- Hover and signature help
            hoverKind = 'FullDocumentation',
            linkTarget = 'pkg.go.dev',
            linksInHover = true,

            -- Does this actually help?
            expandWorkspaceToModule = true,

            -- Static analysis and diagnostics
            staticcheck = true, -- THIS automatically runs the officially supported staticcheck suite

            analyses = {
              -- Only natively supported go vet / gopls checks go here
              asmdecl = true,
              assign = true,
              atomic = true,
              atomicalign = true,
              bools = true,
              buildtag = true,
              cgocall = true,
              composites = true,
              copylock = true,
              defers = true,
              directive = true,
              errorsas = true,
              framepointer = true,
              httpresponse = true,
              ifaceassert = true,
              loopclosure = true,
              lostcancel = true,
              nilfunc = true,
              printf = true,
              shift = true,
              sigchanyzer = true,
              slog = true,
              stdmethods = true,
              stringintconv = true,
              structtag = true,
              testinggoroutine = true,
              tests = true,
              timeformat = true,
              unmarshal = true,
              unreachable = true,
              unsafeptr = true,
              unusedresult = true,
              deepequalerrors = true,
              embed = true,
              fillreturns = true,
              infertypeargs = true,
              nilness = true,
              nonewvars = true,
              noresultvalues = true,
              shadow = true,
              simplifycompositelit = true,
              simplifyrange = true,
              simplifyslice = true,
              sortslice = true,
              stubmethods = true,
              undeclaredname = true,
              unusedparams = true,
              unusedvariable = true,
              unusedwrite = true,
              useany = true,
            },

            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },

            codelenses = {
              gc_details = true,
              generate = true,
              regenerate_cgo = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
              vulncheck = true,
            },

            gofumpt = true,
            directoryFilters = { '-vendor' },
          },
        },

        on_attach = function(client, bufnr)
          if client.name == 'gopls' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.code_action {
                  context = { diagnostics = {}, only = { 'source.organizeImports' } },
                  apply = true,
                }
              end,
            })
          end
        end,
      },
      -- =========================================================================

      pyright = {},
      rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      ts_ls = {
        settings = {},
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          -- Disable format on save for this buffer
          vim.api.nvim_set_option_value('formatoptions', '', { buf = bufnr })
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              -- Do nothing, preventing format on save
            end,
          })
        end,
      },

      stylua = {}, -- Used to format Lua code

      -- Special Lua Config, as recommended by neovim help docs
      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        ---@type lspconfig.settings.lua_ls
        settings = {
          Lua = {
            format = { enable = false }, -- Disable formatting (formatting is done by stylua)
          },
        },
      },
    }
    --
    -- --
    -- -- FORCE GOPLS SETUP
    -- --
    -- local gopls_config = servers.gopls
    -- gopls_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, gopls_config.capabilities or {})
    -- require('lspconfig').gopls.setup(gopls_config)
    --

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'sql-formatter',
      'prettier',
      'staticcheck',
      'goimports',
      'gofumpt',
      'gomodifytags',
      'impl',
      'golangci-lint',
      'delve',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      -- We are removing the handlers block here to prevent Mason
      -- from silently skipping unmanaged/globally-installed binaries.
    }

    -- Ensure lspconfig is loaded so defaults are populated in Nvim 0.11
    require 'lspconfig'

    -- Explicitly set up all servers defined in the servers table.
    for server_name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

      if vim.fn.has 'nvim-0.11' == 1 then
        -- Neovim 0.11+ native config API (prevents deprecation warning)
        local def = vim.lsp.config[server_name] or {}
        vim.lsp.config[server_name] = vim.tbl_deep_extend('force', def, server)
        vim.lsp.enable(server_name)
      else
        -- Neovim 0.10 and earlier legacy API
        require('lspconfig')[server_name].setup(server)
      end
    end
  end,
},
}
