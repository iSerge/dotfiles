--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  -- Git blame a'la vscode gitlens
  'APZelos/blamer.nvim',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- Surround text with symbols or edit surroundings
  'tpope/vim-surround',
  -- Smart repeat commands from plugins
  'tpope/vim-repeat',
  -- Highlight symbols under cursor
  'RRethy/vim-illuminate',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
      'simrat39/rust-tools.nvim',
    },
  },

  'mfussenegger/nvim-lint',

  {
    'stevearc/conform.nvim',
    opts = {},
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
      'jc-doyle/cmp-pandoc-references',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          'n',
          '<leader>gp',
          require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' }
        )
        vim.keymap.set(
          'n',
          '<leader>gn',
          require('gitsigns').next_hunk,
          { buffer = bufnr, desc = '[G]o to [N]ext Hunk' }
        )
        vim.keymap.set(
          'n',
          '<leader>ph',
          require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[P]review [H]unk' }
        )
      end,
    },
  },

  {
    'ishan9299/nvim-solarized-lua',
    priority = 1000,
    config = function()
      vim.opt.background = 'light'
      vim.cmd.colorscheme('solarized')
    end,
  },

  --[[ {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  }, ]]

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- See `:help lualine.txt`
    opts = {
      options = {
        -- icons_enabled = false,
        theme = 'solarized',
        -- component_separators = '|',
        -- section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {
      indent = { char = '┊' },
      -- show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
  },
  'mfussenegger/nvim-dap',
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  'nvim-telescope/telescope-dap.nvim',

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ':TSUpdate',
  },

  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      require('orgmode').setup({
        org_agenda_files = '~/Dropbox/Documents/org/**/*',
        org_default_notes_file = '~/Dropbox/Documents/org/refile.org',
      })
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter', lazy = true },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },

  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup({
        highlight = { pattern = [[.*<(KEYWORDS)\s* ]] },
        search = { pattern = [[\b(KEYWORDS)\b]] },
      })
    end,
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.showbreak = '↪ '
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣', extends = '⟩', precedes = '⟨' }
vim.opt.list = true

-- [[ Basic Keymaps ]]

-- Setting some helpful window and buffers keymaps
local wk = require('which-key')
wk.register({
  g = {
    name = '+git',
    ['1'] = 'which_key_ignore',
  },
  p = {
    name = '+project',
    ['1'] = 'which_key_ignore',
  },
  l = {
    name = '+lsp',
    ['1'] = 'which_key_ignore',
  },
  w = {
    name = '+windows',
    w = { '<C-W>w', 'other-window' },
    d = { '<C-W>c', 'delete-window' },
    ['2'] = { '<C-W>v', 'layout-double-columns' },
    h = { '<C-W>h', 'window-left' },
    j = { '<C-W>j', 'window-below' },
    l = { '<C-W>l', 'window-right' },
    k = { '<C-W>k', 'window-up' },
    H = { '<C-W>5<', 'expand-window-left' },
    J = { '<cmd>resize +5<cr>', 'expand-window-below' },
    L = { '<C-W>5>', 'expand-window-right' },
    K = { '<cmd>resize -5<cr>', 'expand-window-up' },
    ['='] = { '<C-W>=', 'balance-window' },
    s = { '<C-W>s', 'split-window-below' },
    v = { '<C-W>v', 'split-window-right' },
  },
  b = {
    name = '+buffers',
    d = { '<cmd>bp|bd #<cr>', 'delete buffer' },
    n = { '<cmd>bn<cr>', 'next buffer' },
    p = { '<cmd>bp<cr>', 'prev buffer' },
  },
}, { prefix = '<leader>' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'dap')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

require('noice').setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('orgmode').setup_ts_grammar()
require('nvim-treesitter.configs').setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'go',
    'lua',
    'markdown',
    'markdown_inline',
    'org',
    'python',
    'regex',
    'rust',
    'tsx',
    'typescript',
    'vimdoc',
    'vim',
  },
  ignore_install = {},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ps', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[P]roject [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>pa', vim.lsp.buf.add_workspace_folder, '[P]roject [A]dd Folder')
  nmap('<leader>pr', vim.lsp.buf.remove_workspace_folder, '[P]roject [R]emove Folder')
  nmap('<leader>pl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[P]roject [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})

require('lint').linters_by_ft = {
  markdown = { 'vale' },
  cpp = { 'clangtidy', 'clazy' },
  cmake = { 'cmakelint' },
  css = { 'stylelint' },
  typescript = { 'biomejs' },
  javascript = { 'biomejs' },
  javascriptreact = { 'biomejs' },
  json = { 'biomejs' },
  jsonc = { 'biomejs' },
  typescriptreact = { 'biomejs' },
}

local clangtidy = require('lint.linters.clangtidy')
table.insert(clangtidy.args, '-p')
table.insert(clangtidy.args, 'build')

local clazy = require('lint.linters.clazy')
table.insert(clazy.args, '-checks=level2')
table.insert(clazy.args, '-p')
table.insert(clazy.args, 'build')

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = '*',
  callback = function()
    require('lint').try_lint()
  end,
})

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    cpp = { 'clang_format' },
    cmake = { 'cmake_format' },
    css = { 'prettier' },
    typescript = { 'biome' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    json = { 'biome' },
    jsonc = { 'biome' },
    typescriptreact = { 'biome' },
  },
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = '*',
  callback = function(args)
    require('conform').format({ bufnr = args.buf })
  end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'orgmode' },
    { name = 'pandoc_references' },
  },
})

-- Setup DAP configuration
local dap = require('dap')
dap.set_log_level('TRACE')
dap.adapters.cppdbg = {
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
  args = {},
  attach = {
    pidProperty = 'processId',
    pidSelect = 'ask',
  },
}
-- DAP signs
-- vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
-- vim.fn.sign_define('DapBreakpointCondition', {text='❓', texthl='', linehl='', numhl=''})
-- vim.fn.sign_define('DapLogPoint', {text='🧧', texthl='', linehl='', numhl=''})
-- vim.fn.sign_define('DapBreakpointRejected', {text='🚫', texthl='', linehl='', numhl=''})
-- vim.fn.sign_define('DapStopped', {text='🟢', texthl='', linehl='', numhl=''})

-- Setup DAP config by VsCode launch.json file
require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp', 'h' } })

-- Setup DAP keymaps
local dap_continue = function()
  if vim.fn.filereadable('.vscode/launch.json') then
    require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp', 'h' } })
  else
    vim.print('.vscode/launch.json not found')
  end
  require('dap').continue()
end

wk.register({
  d = {
    name = '+debug',
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'DAP: Toggle breakpoint' },
    B = { "<cmd>lua require'dap'.set_breakpoint()<cr>", 'DAP: Set breakpoint' },
    l = {
      "<cmd>lua require'dap'.set_breakpoint(nil,nil,vim.fn.input('Log point message: '))<cr>",
      'DAP: Set log breakpoint',
    },
    C = {
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
      'DAP: Set conditional breakpoint',
    },
    L = { "<cmd>lua require'dap'.list_breakpoints()<cr>", 'DAP: List breakpoints' },
    n = { "<cmd>lua require'dap'.continue()<cr>", 'DAP: Continue' },
    ['<F5>'] = { "<cmd>lua require'dap'.continue()<cr>", 'DAP: Continue' },
    ['<F10>'] = { "<cmd>lua require'dap'.step_over()<cr>", 'DAP: Step over' },
    ['<F11>'] = { "<cmd>lua require'dap'.step_into()<cr>", 'DAP: Step into' },
    ['<F12>'] = { "<cmd>lua require'dap'.step_out()<cr>", 'DAP: Step out' },
    ['_'] = { "<cmd>lua require'dap'.run_last()<cr>", 'DAP: Run last' },
    r = { "<cmd>lua require'dap'.repl.open({}, 'vsplit')<cr>", 'DAP: REPL' },
    -- noremap di
    -- vnoremap di
    ['?'] = { "<cmd>lua require'dap'.ui.variables.scopes()<cr>", 'DAP: Variable scopes' },
    e = { "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<cr>", 'DAP: Set exception breakpoints' },
    a = { "<cmd>lua require'debugHelper'.attach()<cr>", 'DAP: Attach' }, -- Custom function in module debugHelper
    c = { dap_continue, 'DAP: My continue' }, -- Custom wrapper around dap.continue
    h = {
      function()
        require('dap.ui.widgets').hover()
      end,
      'DAP: Hover',
    },
    p = {
      function()
        require('dap.ui.widgets').preview()
      end,
      'DAP: Preview',
    },
    f = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end,
      'DAP: Frames',
    },
    s = {
      function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end,
      'DAP: Scopes',
    },
  },
}, { prefix = '<leader>' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
