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
vim.g.mapleader = ' ' -- Make sure to vim.opt.`mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = ' '

require('lazy').setup({
    'ishan9299/nvim-solarized-lua',
    { 'folke/neodev.nvim', opts = {} },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'simrat39/rust-tools.nvim',

    -- Completion framework 
    'hrsh7th/nvim-cmp',

    -- LSP completion source:
    { 'hrsh7th/cmp-nvim-lsp',
        dependencies = { 'hrsh7th/cmp-nvim-lua', 'hrsh7th/cmp-nvim-lsp-signature-help', 'hrsh7th/cmp-vsnip',
                         'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer', 'hrsh7th/vim-vsnip', },
    },

    -- Useful completion sources:

    { 'nvim-treesitter/nvim-treesitter',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-context' },
        build = ':TSUpdate', },

    -- Telescope search
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },

    { -- Help comment code
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    },
    {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = { }
    },
    { 'RRethy/vim-illuminate' }, -- Highlight symbols under cursor
    { 'tpope/vim-sleuth' }, -- tabstop and shiftwidth heruistics
    { 'tpope/vim-surround' }, -- Surround text with symbols or edit surroundings
    { 'tpope/vim-repeat' }, -- Smart repeat commands from plugins
    { 'APZelos/blamer.nvim'} , -- Git blame a'la vscode gitlens
    { 'ggandor/leap.nvim',
        config = function() require('leap').add_default_mappings() end
    },
    {
        'folke/todo-comments.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup {
                highlight = { pattern = [[.*<(KEYWORDS)\s* ]] },
                search = { pattern = [[\b(KEYWORDS)\b]], }
            }
        end
    },
    { 'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function() require('lualine').setup({}) end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function ()
            require('indent_blankline').setup {
                space_char_blankline = ' ',
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    },
    { 'lewis6991/gitsigns.nvim' },
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
        "rcarriga/nvim-notify",
        }
    },
    { 'mfussenegger/nvim-dap' },
    { 'nvim-telescope/telescope-dap.nvim' },
})

vim.opt.guifont = 'PragmataPro Mono Liga Regular 15'

if vim.fn.has('unnamedplus') == 1 then
    vim.opt.clipboard = 'unnamedplus'
else
    vim.opt.clipboard = 'unnamed'
end

vim.opt.termguicolors = true
vim.opt.background = 'light'

vim.cmd [[ colorscheme solarized ]]

vim.opt.foldenable = true
vim.opt.foldlevelstart=10
vim.opt.foldnestmax=10
vim.opt.foldmethod= 'syntax'

--vim.opt.tabstop = 4
--vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true

vim.opt.number = true -- Show current line number
vim.opt.relativenumber = true -- Show relative line numbers

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Setting up file autocompletion
vim.opt.path:append {'**'}
vim.opt.wildmode = {'longest', 'list', 'full'}
vim.opt.wildmenu = true

vim.opt.showbreak = '↪ '
vim.opt.listchars = {tab = '▸ ', trail = '·', nbsp = '␣', extends = '⟩', precedes = '⟨'}
vim.opt.list = true

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require('neodev').setup({
  -- add any options here, or leave empty to use the default settings
})

-- Mason Setup
require('mason').setup({
    ui = {
        icons = {
            package_installed = '✔',
            package_pending = '➡',
            package_uninstalled = '◯',
        },
    }
})

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason_lspconfig.setup_handlers({
    function(server)
        lspconfig[server].setup({
            capabilities = capabilities
        })
    end
})

-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '⭙'})
sign({name = 'DiagnosticSignWarn', text = '⚠'})
sign({name = 'DiagnosticSignHint', text = '⁉'})
sign({name = 'DiagnosticSignInfo', text = 'ℹ'})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Treesitter Plugin Setup 
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'rust', 'toml' },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Treesitter folding 
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = 'Telescope find files'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Telescope live grep'})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = 'Telescope buffers'})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = 'Telescope help tags'})

require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
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

-- dap
local dap = require("dap")
dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-vscode-14', -- adjust as needed, must be absolute path
	name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, {desc = 'Gitsigns stage hunk'})
    map('n', '<leader>hr', gs.reset_hunk, {desc = 'Gitsigns reset hunk'})
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Gitsigns stage hunk'})
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Gitsigns reset hunk'})
    map('n', '<leader>hS', gs.stage_buffer, {desc = 'Gitsigns stage buffer'})
    map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Gitsigns undo stage hunk'})
    map('n', '<leader>hR', gs.reset_buffer, {desc = 'Gitsigns reset buffer'})
    map('n', '<leader>hp', gs.preview_hunk, {desc = 'Gitsigns preview hunk'})
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Gitsigns blame line'})
    map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = 'Gitsigns toggle current line blame'})
    map('n', '<leader>hd', gs.diffthis, {desc = 'Gitsigns diff this'})
    map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = 'Gitsigns diff this'})
    map('n', '<leader>td', gs.toggle_deleted, {desc = 'Gitsigns toggle deleted'})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = 'Gitsigns select hunk'})
  end
}
