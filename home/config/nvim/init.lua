vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = ""
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.splitright = false
vim.opt.splitbelow = false
vim.opt.incsearch = true
vim.opt.linebreak = true
vim.opt.cursorline = true
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 0
vim.opt.sidescroll = 1
vim.opt.tabpagemax = 100
vim.opt.conceallevel = 2
vim.opt.hlsearch = true
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.termguicolors = true
function todo_add()
  vim.cmd("normal O")
  vim.api.nvim_put({"@todo["..os.date("%y%m%d_%H%M%S").."]"}, "", true, true)
  vim.cmd("Commentary")
  vim.cmd("normal A")
end
function todo_git()
  vim.cmd("silent grep '@todo\\[[0-9]{6}_[0-9]{6}\\]' $(git ls-files)")
  vim.cmd("copen")
end
vim.keymap.set('n', ',,.', '<cmd>term bash<cr>')
vim.keymap.set('n', ',,q', '<cmd>lua todo_git()<cr>')
vim.keymap.set('n', ',,w', '<cmd>term w3m -B<cr>')
vim.keymap.set('n', ',,e', '<cmd>term ranger<cr>')
vim.keymap.set('n', ',,r', '<cmd>term rlwrap sbcl<cr>')
vim.keymap.set('n', ',,t', '<cmd>lua todo_add()<cr>')
vim.keymap.set('n', ',,T', '<cmd>sp|res10|term<cr>')
vim.keymap.set('n', ',,m', '<cmd>term make<cr>')
vim.keymap.set('n', ',,b', '<cmd>b#<cr>')
vim.keymap.set('n', ',,v', '<cmd>vs<cr>')
vim.keymap.set('n', ',,s', '<cmd>sp<cr>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('t', '<C-space>', '<C-\\><C-N>')
vim.keymap.set('n', '<leader>e', '<cmd>Explore<Return>')
vim.g.netrw_banner = 0
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
require("lazy").setup({
  "folke/which-key.nvim",
  {"folke/neoconf.nvim", cmd = "Neoconf"},
  "folke/neodev.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "tpope/vim-fireplace",
  "junegunn/gv.vim",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "junegunn/goyo.vim",
  "airblade/vim-gitgutter",
  "sainnhe/gruvbox-material",
  "xiyaowong/transparent.nvim",
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "tikhomirov/vim-glsl",
  "vlime/vlime",
  "hiphish/nvim-cmp-vlime",
  "hiphish/info.vim",
  "rafamadriz/friendly-snippets",
  "guns/vim-sexp",
  "duane9/nvim-rg",
  { "folke/trouble.nvim", opts = {}, cmd = "Trouble", },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  }
})
require("transparent").setup({
  exclude_groups = {'StatusLine','CursorLine'}
})
require("nvim-treesitter.configs").setup({
  ensure_installed = {"c", "lua", "vim", "vimdoc",},
  highlight = { enable = true, },
})
local lspconfig = require('lspconfig')
lspconfig.clangd.setup{}
vim.cmd("colorscheme gruvbox-material")
local cmp = require('cmp')
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert{
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-g>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm{select = true},
  },
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'vsnip'},
    {name = 'buffer'},
  },{
    {name = 'buffer'},
  }),
}
require('cmp').setup.filetype({'lisp'}, {
    sources = {
        {name = 'vlime'}
    }
})
local vsnip_config = vim.api.nvim_exec(
[[
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]], true)

