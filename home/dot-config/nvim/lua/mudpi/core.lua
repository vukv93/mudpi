return {
  opts = function()
    vim.bo.syntax = 'on'
    vim.opt.smartcase = true
    vim.opt.ignorecase = true
    vim.opt.statusline = "%<%n %f %h%m%r%=%-14.(%l,%c%V%) %P"
    vim.opt.mouse = ""
    vim.opt.autoindent = true
    vim.opt.expandtab = true
    vim.opt.tabstop = 8
    vim.opt.shiftwidth = 2
    vim.opt.shiftround = true
    vim.opt.splitright = false
    vim.opt.splitbelow = false
    vim.opt.incsearch = true
    vim.opt.linebreak = false
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
    vim.g.netrw_banner = 0
  end,
  lazyconfig = {
    "tpope/vim-fugitive",
    "tpope/vim-commentary",
    "junegunn/gv.vim",
    "airblade/vim-gitgutter",
    "sainnhe/gruvbox-material",
    "hiphish/info.vim",
    "tikhomirov/vim-glsl",
    {
      "jlanzarotta/bufexplorer",
      init = function()
        vim.g.bufExplorerDisableDefaultKeyMapping = true
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "c", "commonlisp", "cpp", "lua", "vim", "vimdoc", "markdown",
            "markdown_inline", "r", "rnoweb", "yaml", "css", "make", "json", "haskell",
            "doxygen", "xml", "html", "awk", "scheme", "turtle", "fennel", "latex",
          },
          highlight = { enable = true, },
        })
      end,
    },
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup{}
      end,
    },
    {
      "xiyaowong/transparent.nvim",
      config = function()
        require("transparent").setup({
          exclude_groups = {'StatusLine','CursorLine'}
        })
      end
    },
    -- @todo[240904_181808] Debug quote insertion.
    {
      "guns/vim-sexp",
      init = function()
        vim.g.sexp_enable_insert_mode_mappings = false
      end,
    },
  },
  config = function()
    vim.cmd("colorscheme gruvbox-material")
  end,
  keymaps = function()
    function mudpi_time_add()
      vim.api.nvim_put({os.date("%y%m%d_%H%M%S").." "}, "", true, true)
    end
    function mudpi_todo_add()
      vim.cmd("normal O")
      vim.api.nvim_put({"@todo["..os.date("%y%m%d_%H%M%S").."]"}, "", true, true)
      vim.cmd("Commentary")
      vim.cmd("normal A")
    end
    vim.keymap.set('t', '<C-space>', '<C-\\><C-N>')
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
    vim.keymap.set('n', ',/', '<cmd>noh<cr>')
    vim.keymap.set('n', ',,.', '<cmd>term bash<cr>')
    vim.keymap.set('n', ',,T', '<cmd>sp|term bash<cr>')
    vim.keymap.set('n', ',,b', '<cmd>b#<cr>')
    vim.keymap.set('n', ',,d', '<cmd>Explore<cr>')
    vim.keymap.set('n', ',,g', '<cmd>Git<cr>')
    vim.keymap.set('n', ',,l', '<cmd>BufExplorer<cr>')
    vim.keymap.set('n', ',,m', '<cmd>term make<cr>')
    vim.keymap.set('n', ',,n', '<cmd>:e $NOUUA/index.md<cr>')
    vim.keymap.set('n', ',,q', '<cmd>Ggrep -qrE "@todo\\[[0-9]{6}_[0-9]{6}\\]"<cr>')
    vim.keymap.set('n', ',,t', '<cmd>lua mudpi_todo_add()<cr>')
    vim.keymap.set('n', ',,,t', '<cmd>lua mudpi_time_add()<cr>')
    vim.keymap.set('n', ',,,w', '<cmd>Git blame -e<cr>')
    vim.keymap.set('n', ',,s', '<cmd>sp<cr>')
    vim.keymap.set('n', ',,v', '<cmd>vs<cr>')
    vim.keymap.set('n', ',,w', '<cmd>term w3m -B<cr>')
    vim.keymap.set('n', ',,z', '<cmd>term emacs<cr>')
    vim.keymap.set('n', ',,r', '<cmd>term rlwrap sbcl<cr>')
  end,
}
