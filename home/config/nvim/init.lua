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
vim.opt.list = false
vim.opt.listchars = "tab:<->,trail:-,nbsp:+,leadmultispace:|·,eol:$,space:·"
function todo_add()
  vim.cmd("normal O")
  vim.api.nvim_put({"@todo["..os.date("%y%m%d_%H%M%S").."]"}, "", true, true)
  vim.cmd("Commentary")
  vim.cmd("normal A")
end
function todo_git_ls()
  vim.cmd("silent grep '@todo\\[[0-9]{6}_[0-9]{6}\\]' $(git ls-files)")
  vim.cmd("copen")
end
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
  "jlanzarotta/bufexplorer",
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "tpope/vim-fireplace",
  "junegunn/gv.vim",
  "junegunn/fzf",
  "junegunn/fzf.vim",
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
  "hiphish/info.vim",
  "rafamadriz/friendly-snippets",
-- @todo[240904_181808] Debug quote insertion.
  "guns/vim-sexp",
  "duane9/nvim-rg",
  "monkoose/parsley",
  {
    "monkoose/nvlime",
    init = function()
      vim.g.nvlime_config = {cmp = {enabled = true}}
    end
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end
  },
  "hrsh7th/cmp-nvim-lsp-signature-help",
  --"olical/conjure",
  --"paterjason/cmp-conjure",
  --"vlime/vlime",
  --"hiphish/nvim-cmp-vlime",
--  {
--    "sakhnik/nvim-gdb",
--    init = function()
--      vim.g.nvimgdb_config_override = {
--        termwin_command = 'aboveleft vnew',
--        codewin_command = 'vnew',
--      }
--    end
--  },
  "mfussenegger/nvim-dap",
  "LiadOz/nvim-dap-repl-highlights",
  { "folke/trouble.nvim", opts = {}, cmd = "Trouble", },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "R-nvim/R.nvim",
    lazy = false
  },
  "R-nvim/cmp-r",
})
require("transparent").setup({ exclude_groups = {'StatusLine','CursorLine'}})
require('nvim-dap-repl-highlights').setup()
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c", "commonlisp", "cpp", "lua", "vim", "vimdoc", "markdown",
    "markdown_inline", "r", "rnoweb", "yaml", "css", "make", "json", "haskell",
    "doxygen", "xml", "html", "awk", "scheme", "turtle", "fennel", "latex",
    "dap_repl",
  },
  highlight = { enable = true, },
})
local lspconfig = require('lspconfig')
lspconfig.clangd.setup{}
lspconfig.bashls.setup{}
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
    {name = 'path'},
    {name = "cmp_r"},
    {name = "nvim_lsp_signature_help"},
    --{name = "conjure"},
  },{
    {name = 'buffer'},
  }),
}
cmp.setup.filetype({'sh'}, {sources = {{name = 'bash-language-server'}}})
require("cmp_r").setup({})
cmp.setup.filetype({'lisp'}, {sources = {{name = 'nvlime'}}})
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/home/vukv/opt/llvm-18/bin/lldb-dap',
  name = 'lldb'
}
local dap = require('dap')
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
    repl_lang = 'cpp',
  },
}
dap.configurations.c = dap.configurations.cpp
-- @todo[240905_072430] Test Rust debugging.
dap.configurations.rust = {
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
    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
      local commands = {}
      local file = io.open(commands_file, 'r')
      if file then
        for line in file:lines() do
          table.insert(commands, line)
        end
        file:close()
      end
      table.insert(commands, 1, script_import)
      return commands
    end,
  },
}
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

vim.keymap.set('n', ',,.', '<cmd>term bash<cr>')
vim.keymap.set('n', ',,q', '<cmd>lua todo_git_ls()<cr>')
vim.keymap.set('n', ',,w', '<cmd>term w3m -B<cr>')
vim.keymap.set('n', ',,e', '<cmd>term ranger<cr>')
vim.keymap.set('n', ',,r', '<cmd>term rlwrap sbcl<cr>')
vim.keymap.set('n', ',,t', '<cmd>lua todo_add()<cr>')
vim.keymap.set('n', ',,h', '<cmd>noh<cr>')
vim.keymap.set('n', ',,g', '<cmd>Git<cr>')
vim.keymap.set('n', ',,T', '<cmd>sp|res10|term<cr>')
vim.keymap.set('n', ',,m', '<cmd>term make<cr>')
vim.keymap.set('n', ',,b', '<cmd>b#<cr>')
vim.keymap.set('n', ',,v', '<cmd>vs<cr>')
vim.keymap.set('n', ',,s', '<cmd>sp<cr>')
vim.keymap.set('n', ',,z', '<cmd>term emacs<cr>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('t', '<C-space>', '<C-\\><C-N>')
vim.keymap.set('n', '<leader>e', '<cmd>Explore<Return>')
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>da', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>ds', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>de', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>bb', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>BB', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function()
  require('dap').repl.open({},"aboveleft vsplit")
end)
vim.keymap.set('n', '<Leader>dS', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dw', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dq', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>dv', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")
