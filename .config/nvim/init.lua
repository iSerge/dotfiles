local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- Make sure to vim.opt.`mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

require("lazy").setup({
    'ishan9299/nvim-solarized-lua',
    { "folke/neodev.nvim", opts = {} },
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
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        build = ":TSUpdate", },

    -- Telescope search
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },

    { -- Help comment code
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = { }
    },
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

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
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
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✔",
            package_pending = "➡",
            package_uninstalled = "◯",
        },
    }
})

require("mason-lspconfig").setup()

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
        vim.fn["vsnip#anonymous"](args.body)
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
  ensure_installed = { "lua", "rust", "toml" },
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


