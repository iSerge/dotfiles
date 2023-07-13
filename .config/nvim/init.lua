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

require("lazy").setup({
    'ishan9299/nvim-solarized-lua',
    { "folke/neodev.nvim", opts = {} },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
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

