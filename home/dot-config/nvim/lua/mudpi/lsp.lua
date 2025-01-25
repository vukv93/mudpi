return {
  lazyconfig = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "rafamadriz/friendly-snippets",
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require('lspconfig')
        lspconfig.clangd.setup{}
      end
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require'cmp'
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
            {name = "orgmode"},
            --{name = "conjure"},
          },{
            {name = 'buffer'},
          }),
        }
        --cmp.setup.filetype({'sh'}, {sources = {{name = 'bash-language-server'}}})
        cmp.setup.filetype({'lisp'}, {sources = {{name = 'nvlime'}}})
      end
    },
    {
      "mfussenegger/nvim-dap",
      config = function()
        local dap = require('dap')
        dap.adapters.lldb = {
          type = 'executable',
          command = os.getenv('HOME') .. '/opt/bin/lldb-dap',
          name = 'lldb',
        }
        dap.configurations.cpp = {
          {
            name = 'lldb-prompt',
            type = 'lldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            repl_lang = 'cpp',
            -- @todo[250105_215932] For Rust also?
            disableASLR = false, -- @note[250105_220037] https://stackoverflow.com/questions/76939386/lldb-error-cannot-launch-a-out-personality-set-failed-operation-not-permitted
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
              -- @todo[240908_174628] Find pretty printer Python module
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
      end
    },
    {
      "LiadOz/nvim-dap-repl-highlights",
      config = function()
        require('nvim-dap-repl-highlights').setup()
      end
    },
  },
  config = function()
    -- Vsnip configuration.
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
  end,
  keymaps = function()
    -- @todo[250105_172914] Full feature testing on mudpi.
    -- @todo[250105_173022] GDB, DAP for starters.
    -- Language server maps.
    local function quickfix()
      vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
      })
    end
    vim.keymap.set('n', '<leader>qf', quickfix, {noremap=true, silent=true})
    -- DAP maps.
    vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
    vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end)
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
  end,
}
