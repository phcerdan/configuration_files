-- Install lazy
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

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.termguicolors = true

require('lazy').setup({
  -- Colorscheme, config needs to be done in init.lua
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        contrast = "hard"
      })
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          numbers = function(opts)
            return string.format('%s', opts.id)
          end,
        }
      })
    end,
  },
  { -- zoom with Goyo, Goyo! distraction free
    "junegunn/goyo.vim",
    config = function()
      vim.g.goyo_width = 120
      vim.g.goyo_height = 95
    end,
    keys = {
      { "<leader>z", "<cmd>Goyo<cr>", desc = "Goyo Toggle" },
    },
  },
  { -- Provide nice vim.ui.select/vim.ui.input
    "stevearc/dressing.nvim",
    lazy = false,
    config = true,
    -- vim.ui.select({'apple', 'banana', 'mango'}, { prompt = "Title"}, function(selected) end)
  },
  -- Tmux related
  { "christoomey/vim-tmux-navigator", lazy = false }, -- Navigate vim/tmux with same keys: <c-hjkl>
  { "jpalardy/vim-slime",             lazy = false }, -- Send/Copy from vim to other tmux pane
  -- Utils
  { "folke/neodev.nvim",              config = true }, -- Additional lua configuration, makes nvim stuff amazing
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  -- jupyter notebook
  { -- install nvim-notify
    "rcarriga/nvim-notify",
    config = true,
  },
  { -- jupytext
    "goerz/jupytext.vim", build = "pip3 install --user .",
  },
  -- { -- UNUSED
  --   "kiyoon/jupynium.nvim",
  --   build = "pip3 install --user .",
  --   -- build = "conda run --no-capture-output -n jupynium pip install .",
  --   -- enabled = vim.fn.isdirectory(vim.fn.expand "~/miniconda3/envs/jupynium"),
  -- },
  -- orgmode {{{
  -- neorg
  -- {
  --   "nvim-neorg/neorg",
  --   ft = "norg", -- lazy load on filetype
  --   cmd = "Neorg", -- lazy load on command, allows autocomplete :Neorg
  --   opts = {
  --     load = {
  --       ["core.defaults"] = {},
  --       ["core.norg.concealer"] = {},
  --       ["core.norg.completion"] = {
  --         config = { engine = "nvim-cmp" },
  --       },
  --       ["core.integrations.nvim-cmp"] = {},
  --       ["core.norg.dirman"] = {
  --         config = {
  --           workspaces = {
  --             notes = "~/notes/norg",
  --           },
  --           index = "index.norg",
  --           default_workspace = "notes",
  --         },
  --       },
  --     },
  --   },
  -- }, -- NOT SURE, going to orgmode instead
  -- orgmode
  { 'nvim-orgmode/orgmode', lazy = false, },
  -- { -- highlight for orgmode, md and neorg
  --   'lukas-reineke/headlines.nvim',
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = true,
  -- },
  -- }}}
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },
  { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  -- quickfix navigation
  { "romainl/vim-qf", lazy = false, },
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  { 'kylechui/nvim-surround', config = true },
  { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },
  { 'rhysd/committia.vim',   lazy = false }, -- More pleasant commit layout
  'rhysd/git-messenger.vim', -- Show git commit diff in pop-up window: <Leader>gm
  "junegunn/gv.vim", --:GV for commit browser, GV! for one this file, GV? fills location list.
  "shumphrey/fugitive-gitlab.vim", -- Gbrowse works in gitlab
  "tpope/vim-obsession", -- Save sessions :Obsess, Restore vim -S. Also used by tmux-resurrect
  "tpope/vim-abolish", -- Subsitutions with plurals, cases, etc.
  "tpope/vim-unimpaired", -- Add ][q (cnext), ][b (bnext), ][Space (add new lines)
  "ntpeters/vim-better-whitespace", -- Highlight whitespaces and provide StripWhiteSpaces()
  { 'nvim-lualine/lualine.nvim', -- Fancier statusline
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox',
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end,
  },
  { 'numToStr/Comment.nvim', config = true }, -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- Asyncrun
  'skywind3000/asyncrun.vim', -- async :! command, read output using error format, or use % raw to ignore.
  'powerman/vim-plugin-AnsiEsc', -- For escaping terminal colors in vim
  'mh21/errormarker.vim', -- " errormarker to display errors of asyncrun , https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
  "andymass/vim-matchup", -- Extends % functionality
  "wsdjeg/vim-fetch", -- Enable opening files with format: vim file_name.xxx:line,col
  "vim-scripts/restore_view.vim", -- Restore file position and FOLDS.
  "rhysd/vim-clang-format", -- :ClangFormat (c,cpp)
  "psf/black", -- :Black (python)
  "theprimeagen/harpoon", -- Most used files
  -- ui
  { -- floating winbar
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  -- IDE options --
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    config = function()
      require("refactoring").setup({
        -- overriding printf statement for cpp
        printf_statements = {
          -- add a custom printf statement for cpp
          cpp = {
            'std::cout << "%s" << std::endl;'
          }
        },
        -- overriding printf statement for cpp
        print_var_statements = {
          -- add a custom print var statement for cpp
          cpp = {
            'std::cout << "%s " << %s << std::endl;'
          }
        },
      })
    end,
  },
  'nvim-tree/nvim-web-devicons',
  -- Completion --
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "onsails/lspkind-nvim",
  "tamago324/cmp-zsh",
  -- DAP (Debug Adapter Protocol) --
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "rcarriga/cmp-dap", -- nvim-cmp soruce for nvim-dap REPL and nvim-dap-ui buffers
  { "theHamsta/nvim-dap-virtual-text", config = true },
  { "mhinz/vim-grepper" },
  -- Fuzzy Finder (files, lsp, etc)
  { 'junegunn/fzf',
    build = { vim.fn['fzf#install'] }
  },
  {
    'ibhagwan/fzf-lua',
    config = function()
      require('fzf-lua').setup {
        winopts = {
          vertical = 'up:50%',
          -- win_height = 0.8,
          -- win_width = 0.8,
          -- win_row = 0.5,
          -- win_col = 0.5,
        },
        fzf_layout = 'default',
        -- fzf_preview_window = 'right:60%:hidden',
      }
    end,
  },
  { 'junegunn/fzf.vim' }, -- just for :Maps
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  { -- vim-rooter to avoid telscope change pwd when grepping or finding files...
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_patterns = { '.git', '.svn', '.hg', '.project', '.root', 'package.json', '>site-packages' }
    end,
  },
  --  DAP: Adaparter configuration for specific languages
  "mfussenegger/nvim-dap-python",
  -- Buffer helpers
  'vim-scripts/BufOnly.vim', -- :BOnly deltes all buffers except current one.
  'moll/vim-bbye', -- Bdelete, as Bclose, deleting buffers without deleting windows.
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  },
  -- Copilot --
  { "github/copilot.vim",                       lazy = false },
  -- The nvim plugin doesn't handle multiline ghost
  -- use { "zbirenbaum/copilot.lua" ,
  --   config = function()
  --     require("copilot").setup()
  --   end
  -- }
  -- use { "zbirenbaum/copilot-cmp", -- not ready --
  --   opt = false,
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- }
  -- ChatGPT
  { "jackMort/ChatGPT.nvim",
    config = true,
    cond = function()
      return os.getenv("OPENAI_API_KEY") ~= nil
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
})

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
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { -- ignore all files in scratch directory
      "^scratch/"
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-q>'] = function(bufnr)
          require('telescope.actions').smart_send_to_qflist(bufnr)
          -- open quickfix list if it's not already open
          if vim.fn.getqflist({ winid = 0 }).winid == 0 then
            vim.cmd [[copen]]
          end
        end
      },
    },
    preview = {
      -- truncate the previewer if file is too long:
      -- https://github.com/nvim-telescope/telescope.nvim/issues/623
      filesize_hook = function(filepath, bufnr, opts)
        local max_bytes = 10000
        local cmd = { "head", "-c", max_bytes, filepath }
        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
      end
    }
  },
  -- extensions = {
  --   fzf = {
  --     fuzzy = true,                    -- false will only do exact matching
  --     override_generic_sorter = false, -- override the generic sorter
  --     override_file_sorter = true,     -- override the file sorter
  --     case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
  --   },
  -- },

}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sa', function(args) print(args) end, { desc = '[S]earch With FZF' })

vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader><space>', require('fzf-lua').buffers, { desc = '[S]earch Open buffers' })
vim.keymap.set('n', '<leader>sg', require('fzf-lua').live_grep, { desc = '[S]earch [G]rep' })
vim.keymap.set('n', '<leader>sl', require('fzf-lua').grep_last, { desc = '[S]earch [L]ast' })
vim.keymap.set('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch [W]ord' })


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'typescript', 'help', 'vim', 'org', },
    -- , 'orgagenda'},

  highlight = {
    enable = true,
    disable = function(lang, bufnr) -- Disable in files with many lines or a really large first line (json)
      local large_line = vim.api.nvim_strwidth(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]) > 1000
      local large_file = vim.api.nvim_buf_line_count(bufnr) > 50000
      local disable_it = large_line or large_file
      if disable_it then
        vim.opt.syntax = 'off'
        print('Treesitter disabled for ' .. lang)
      end
      return disable_it
    end,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
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
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
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
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

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
local servers_settings = {
  clangd = {},
  -- gopls = {},
  pyright = {
    python = {
      analysis = {
        reportPrivateImportUsage = false,
      },
    },
  },
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers_settings),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers_settings[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'dap' },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      -- require("copilot_cmp.comparators").prioritize,
      -- require("copilot_cmp.comparators").score,
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  formatting = {
    -- Youtube: How to set up nice formatting for your sources.
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
        gh_issues = "[issues]",
        tn = "[TabNine]",
      },
    },
  },
  -- From cmp_dap
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      or require("cmp_dap").is_dap_buffer()
  end,

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = false,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
