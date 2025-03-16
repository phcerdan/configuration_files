-- Set host dependant variables, like python_host_prog
require("user.local")

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
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.termguicolors = true

local linters = {
  lua = { "luacheck" },
  css = { "stylelint" },
  sh = { "shellcheck" },
  markdown = { "markdownlint" },
  yaml = { "yamllint" },
  python = { "ruff" },
  -- cpp = { 'clang-tidy'}, lsp clangd will use this
  -- c = { 'clang-tidy'},
  vim = { "vint" },
}

local formatters = {
  lua = { "stylua" },
  python = { "black", "ruff" },
  cpp = { "clang-format" },
  javascript = { { "prettierd", "prettier" }, "jq", "biome" },
  sh = { "shfmt" },
  cmake = { "cmakelang" },
}

local function create_cmd_FormatEnable()
  vim.api.nvim_create_user_command("FormatEnable", function(args)
    if args.bang then
      -- FormatEnable! will enable formatting on save just for this buffer
      vim.b.enable_autoformat = true
    else
      vim.g.enable_autoformat = true
    end
  end, {
    desc = "Enable autoformat-on-save",
    bang = true,
  })
  vim.api.nvim_create_user_command("FormatDisable", function()
    vim.g.enable_autoformat = false
    vim.b.enable_autoformat = false
  end, {
    desc = "Disable autoformat-on-save",
  })
end

local debuggers = {
  python = { "debugpy" },
  cpp = {"cpptools"},
}

local dontInstall = {
  -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
  "stylelint",
  -- not real formatters, but pseudo-formatters from conform.nvim
  "trim_whitespace",
  "trim_newlines",
  "squeeze_blanks",
  "injected",
}

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param myDebuggers string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
local function toolsToAutoinstall(myLinters, myFormatters, myDebuggers, ignoreTools)
  -- get all linters, formatters, & debuggers and merge them into one list
  local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
  local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
  local tools = vim.list_extend(linterList, formatterList)
  vim.list_extend(tools, myDebuggers)

  -- only unique tools
  table.sort(tools)
  tools = vim.fn.uniq(tools)

  -- remove exceptions not to install
  tools = vim.tbl_filter(function(tool)
    return not vim.tbl_contains(ignoreTools, tool)
  end, tools)
  return tools
end

require("lazy").setup({
  {
    "lervag/vimtex",
    config = function()
      local file = vim.fn.expand("~/.config/nvim/after/plugin/latex.vim")
      vim.cmd("source " .. file)
    end,
  },
  { -- jinja syntax
    "Glench/Vim-Jinja2-Syntax",
  },
  {
    "phcerdan/a.vim", -- :A to switch between h, c files. Fork to switch between h and hxx (ITK)
  },
  -- {
  --   "Konfekt/FastFold",
  --   config = function()
  --     vim.g.fastfold_savehook = 0 -- Only update manually with keys: zuz, or when :FastFoldUpdate
  --     vim.g.tex_fold_enabled = 1
  --     vim.g.vimsyn_folding = "af"
  --     -- vim.g.cpp_folding = 1
  --     -- vim.g.vim_folding = 1
  --     -- vim.g.python_folding = 1
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "cpp", "lua", "python", "rust", "typescript", "vimdoc", "vim", "norg" },
        -- , 'orgagenda'},
        ignore_install = { "comment" },

        highlight = {
          enable = true,
          disable = function(lang, bufnr) -- Disable in files with many lines or a really large first line (json)
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if ft == "text" or ft == "qf" then
              return true
            end

            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
            local first_line = lines[1] or ""  -- Defaults to an empty string if nil
            local large_line = vim.api.nvim_strwidth(first_line) > 1000
            local large_file = vim.api.nvim_buf_line_count(bufnr) > 50000
            local disable_it = large_line or large_file
            if disable_it then
              vim.opt.syntax = false
              print("Treesitter disabled for " .. lang)
            end
            return disable_it
          end,
          -- Required for spellcheck, some LaTex highlights and
          -- code block highlights that do not have ts grammar
          additional_vim_regex_highlighting = { "org" },
        },
        indent = { enable = true }, --, disable = { "python" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    init = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = '1'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldmethod = "expr"
    end,
    keys = {
      {'zR',
        function()
          require('ufo').openAllFolds()
        end,
        mode = {"n"}, desc = "Open All Folds"
      },
      {'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        mode = {"n"}, desc = "Close All Folds"
      },
      {'zm',
        function()
          require('ufo').closeFoldsWith()
        end,
        mode = {"n"}, desc = "Close fold by level: zm, 1zm"
      },
      {
          "<leader>F",
          function()
              local ufo = require("ufo")
              local winid = ufo.peekFoldedLinesUnderCursor()
              if not winid then
                  -- Fallback to hover using LSP if no fold is found
                  vim.lsp.buf.hover()
              end
          end,
          mode = "n",
          desc = "Peek under the fold"
      },
    },
    opts = {
      provider_selector = function()
        return {"treesitter", "indent"}
      end,
    },
  },
  {"nvim-treesitter-context"},
  {"nvim-treesitter-textobjects"},

  -- Colorscheme, config needs to be done in init.lua
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,  -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("gruvbox").setup({
  --       contrast = "hard",
  --     })
  --     vim.cmd([[colorscheme gruvbox]])
  --   end,
  -- },
  -- {
  --   'sainnhe/gruvbox-material',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Optionally configure and load the colorscheme
  --     -- directly inside the plugin declaration.
  --     vim.g.gruvbox_material_enable_italic = true
  --     vim.g.gruvbox_material_background = 'hard'
  --     vim.g.gruvbox_material_foreground = 'original'
  --     vim.cmd.colorscheme('gruvbox-material')
  --   end
  -- },
  -- {
  --   "ramilito/winbar.nvim",
  --   event = "VimEnter", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("winbar").setup({
  --       -- your configuration comes here, for example:
  --       icons = true,
  --       diagnostics = true,
  --       buf_modified = true
  --     })
  --   end
  -- },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = function(opts)
            return string.format("%s", opts.id)
          end,
        },
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
  {
    "christoomey/vim-tmux-navigator",
    event = "BufReadPre",
    config = function()
        vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { "jpalardy/vim-slime",               lazy = false }, -- Send/Copy from vim to other tmux pane
  -- Utils
  { "jbyuki/one-small-step-for-vimkind" },           -- dap adapter for lua running inside neovim
  { "folke/neodev.nvim",                config = true }, -- Additional lua configuration, makes nvim stuff amazing
  { "nvim-tree/nvim-web-devicons" },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd="Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    -- markdown preview
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- jupyter notebook
  {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",
    version = "1.1.0",
    integrations = {
      markdown = { enabled = false },
    },                -- disable all integrations. Used in Molten only.
    opts = {
      backend = "kitty", -- Kitty will provide the best experience, but you need a compatible terminal
      integrations = {
        markdown = { enabled = false },
      },                                     -- do whatever you want with image.nvim's integrations
      max_width = 100,                       -- tweak to preference
      max_height = 12,                       -- ^
      max_height_window_percentage = math.huge, -- this is necessary for a good experience
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      -- Keymaps
      vim.keymap.set(
        "n",
        "<localleader>R",
        ":MoltenEvaluateOperator<CR>",
        { silent = true, noremap = true, desc = "run operator selection" }
      )
      vim.keymap.set(
        "n",
        "<localleader>rr",
        ":MoltenEvaluateLine<CR>",
        { silent = true, noremap = true, desc = "evaluate line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>rc",
        ":MoltenReevaluateCell<CR>",
        { silent = true, noremap = true, desc = "re-evaluate cell" }
      )
      vim.keymap.set(
        "v",
        "<localleader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, noremap = true, desc = "evaluate visual selection" }
      )
    end,
  },
  { -- install nvim-notify
    "rcarriga/nvim-notify",
    config = true,
  },
  { -- jupytext
    "goerz/jupytext.vim",
    build = "pip3 install --user .",
  },
  {
    "vim-scripts/DoxygenToolkit.vim",
    config = function()
      vim.g.DoxygenToolkit_briefTag_pre = '' -- Remove @brief tag. (First line will be parsed as brief anyway).
    end,
  },
  { -- kitty conf highlight
    "fladson/vim-kitty",
  },
  {
    "Al0den/notion.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
        require"notion".setup({

    keys = { --Menu keys
        deleteKey = "d",
        editKey = "e",
        openNotion = "o",
        itemAdd = "a",
        viewKey = "v"
    },
      })
    end,
  },
  {
    "mickael-menu/zk-nvim",
    config = function()
      require("zk").setup()
      require("zk").picker = "fzf"
      -- Create a new note after asking for its title.
      vim.api.nvim_set_keymap(
        "n",
        "<leader>zn",
        "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        { noremap = true, silent = false }
      )
      -- Open notes.
      vim.api.nvim_set_keymap(
        "n",
        "<leader>zo",
        "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        { noremap = true, silent = false }
      )
      -- Open notes associated with the selected tags.
      vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", { noremap = true, silent = false })
      -- Search for the notes matching a given query.
      vim.api.nvim_set_keymap(
        "n",
        "<leader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        { noremap = true, silent = false }
      )
      -- Search for the notes matching the current visual selection.
      vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", { noremap = true, silent = false })
    end,
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
  { "nvim-orgmode/orgmode", lazy = false },
  -- { -- highlight for orgmode, md and neorg
  --   'lukas-reineke/headlines.nvim',
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   config = true,
  -- },
  -- }}}
  -- Yank/Cut control {{{
  -- { -- Cutlass overrides the delete operations to actually just delete and not affect the current yank.
  --   "gbprod/cutlass.nvim",
  --   opts = {
  --     cut_key = "m",
  --   }
  -- },
  -- }}}
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", branch = "legacy" },

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
  },
  { -- auto-install missing linters & formatters
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local myTools = toolsToAutoinstall(linters, formatters, debuggers, dontInstall)

      require("mason-tool-installer").setup({
        ensure_installed = myTools,
        run_on_start = false, -- triggered manually, since not working with lazy-loading
      })

      -- clean unused & install missing
      vim.defer_fn(vim.cmd.MasonToolsInstall, 500)
      -- vim.defer_fn(vim.cmd.MasonToolsClean, 1000) -- delayed, so noice.nvim is loaded before
    end,
  },
  --- Install efmls and configs
  {
    'creativenull/efmls-configs-nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp-signature-help",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },
  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    enabled = true,
    opts = { mode = "cursor" },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  {
    "stevearc/aerial.nvim",
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      layout = {
        resize_to_content = false,
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
    dependencies = {
      "onsails/lspkind-nvim",
    },
  },
  -- quickfix navigation
  -- { "romainl/vim-qf",       lazy = false },
  {
    "stevearc/quicker.nvim", -- This allows to substitute directly from qlist, instead of :cdo
    config = function()
      require("quicker").setup({
        highlight = {
          load_buffers = true, -- the default is true and it is incredibly slow
        },
        keys = {
          { ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end, desc = "Expand quickfix context",
          },
          { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context", },
        },
      })
    end,
    keys = {
      { "<leader>q", mode = {"n"}, function() require("quicker").toggle({ open_cmd_mods = { split = "botright" }}) end, desc = "Quickfix Toggle" },
      { "<leader>l", mode = {"n"}, function() require("quicker").toggle({ open_cmd_mods = { split = "botright" }, loclist=true}) end, desc = "Loclist Toggle" },
    },
    max_filename_width = function()
      return math.floor(math.min(20, vim.o.columns / 2))
    end,
  },
  -- jump around
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  { "kylechui/nvim-surround", config = true },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "+" },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          -- stylua: ignore start
          map("n", "]h", gs.next_hunk, "Next Hunk")
          map("n", "[h", gs.prev_hunk, "Prev Hunk")
          map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
          map("n", "<leader>ghd", gs.diffthis, "Diff This")
          map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      })
    end,
  },
  {
    "rhysd/committia.vim", -- More pleasant commit layout
    lazy=false,
    config = function()
      -- Enable committia, even with vim-fugitive
      vim.g.committia_open_only_vim_starting = 0
    end,

  },
  "rhysd/git-messenger.vim",              -- Show git commit diff in pop-up window: <Leader>gm
  "junegunn/gv.vim",                      --:GV for commit browser, GV! for one this file, GV? fills location list.
  "shumphrey/fugitive-gitlab.vim",        -- Gbrowse works in gitlab
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
      }
    end
  },
  "tpope/vim-abolish",                    -- Subsitutions with plurals, cases, etc.
  "tpope/vim-unimpaired",                 -- Add ][q (cnext), ][b (bnext), ][Space (add new lines)
  "ntpeters/vim-better-whitespace",       -- Highlight whitespaces and provide StripWhiteSpaces()
  {
    "nvim-lualine/lualine.nvim",          -- Fancier statusline
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",
          icons_enabled = false,
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup({
        indent = { char = "┊" },
      })
    end,
  },
  { "numToStr/Comment.nvim",           config = true }, -- "gc" to comment visual regions/lines
  -- "tpope/vim-sleuth",                        -- Detect tabstop and shiftwidth automatically. Really SLOW
  {
    "NMAC427/guess-indent.nvim", -- faster than vim-sleuth
    config = true,
  },
  -- Asyncrun
  "skywind3000/asyncrun.vim",                -- async :! command, read output using error format, or use % raw to ignore.
  "powerman/vim-plugin-AnsiEsc",             -- For escaping terminal colors in vim
  "mh21/errormarker.vim",                    -- " errormarker to display errors of asyncrun , https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
  -- "andymass/vim-matchup",                    -- Extends % functionality. Terribly slow
  "wsdjeg/vim-fetch",                        -- Enable opening files with format: vim file_name.xxx:line,col
  "vim-scripts/restore_view.vim",            -- Restore file position and FOLDS.
  "rhysd/vim-clang-format",                  -- :ClangFormat (c,cpp)
  --- Chat GPT {{{
  -- {
  --   "Robitx/gp.nvim",
  --   config = function()
  --     require("gp").setup()
  --     local function keymapOptions(desc)
  --       return {
  --         noremap = true,
  --         silent = true,
  --         nowait = true,
  --         desc = "GPT prompt " .. desc,
  --       }
  --     end
  --
  --     -- Chat commands
  --     vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Popup Chat"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))
  --
  --     vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
  --     vim.keymap.set("v", "<C-g>v", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
  --     vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Popup Chat"))
  --
  --     vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
  --     vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
  --     vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))
  --
  --     vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
  --     vim.keymap.set(
  --       "v",
  --       "<C-g><C-v>",
  --       ":<C-u>'<,'>GpChatNew vsplit<cr>",
  --       keymapOptions("Visual Chat New vsplit")
  --     )
  --     vim.keymap.set(
  --       "v",
  --       "<C-g><C-t>",
  --       ":<C-u>'<,'>GpChatNew tabnew<cr>",
  --       keymapOptions("Visual Chat New tabnew")
  --     )
  --
  --     -- Prompt commands
  --     vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>e", "<cmd>GpEnew<cr>", keymapOptions("Enew"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>p", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
  --
  --     vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
  --     vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append"))
  --     vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend"))
  --     vim.keymap.set("v", "<C-g>e", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual Enew"))
  --     vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
  --   end,
  -- },
  -- -- Send diagnostics to ChatGPT
  -- {
  --   "piersolenski/wtf.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = {
  --     -- https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo
  --     -- gpt4-turbo:
  --     openai_model_id = "gpt-4-1106-preview",
  --   },
  --   keys = {
  --     {
  --       "gw",
  --       mode = { "n", "x" },
  --       function()
  --         require("wtf").ai()
  --       end,
  --       desc = "Debug diagnostic with AI",
  --     },
  --     {
  --       mode = { "n" },
  --       "gW",
  --       function()
  --         require("wtf").search()
  --       end,
  --       desc = "Search diagnostic with Google",
  --     },
  --   },
  -- },
  --- }}}
  {
    "psf/black",                  -- :Black (python)
    config = function()
      vim.g.black_use_virtualenv = 0 -- use black from python3_host_prog
      vim.g.black_linelength = 100 -- default 88
    end,
  },
  -- ui
  -- { -- floating winbar
  --   "b0o/incline.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require("incline").setup({
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  --         local icon, color = require("nvim-web-devicons").get_icon_color(filename)
  --         return { { icon, guifg = color }, { " " }, { filename } }
  --       end,
  --     })
  --   end,
  -- },
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
            'std::cout << "%s" << std::endl;',
          },
        },
        -- overriding printf statement for cpp
        print_var_statements = {
          -- add a custom print var statement for cpp
          cpp = {
            'std::cout << "%s " << %s << std::endl;',
          },
        },
      })
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    config = true,
    dependencies = {
        "echasnovski/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim <= 0.9
        "nvim-treesitter/nvim-treesitter" -- Needed to enable treesitter for NeoVim 0.8
    },
    -- Remove the following line to use development versions,
    -- not just the formal releases
    version = "*",
  },
  -- Completion --
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "onsails/lspkind-nvim",
  "tamago324/cmp-zsh",
  -- DAP (Debug Adapter Protocol) --
  {
    "mfussenegger/nvim-dap",
    -- dependencies = {
    --   { "igorlfs/nvim-dap-view", -- alternative to nvim-dap-ui, not ready yet (Jan 2025)
    --     opts = {},
    --     keys = {
    --       { 'F4', function() require('dap-view').toggle() end, desc="Toggle dap-view"},
    --     },
    --   },
    -- },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    -- "rcarriga/cmp-dap", -- nvim-cmp source for nvim-dap REPL and nvim-dap-ui buffers
    },
  },
  { "theHamsta/nvim-dap-virtual-text", config = true },
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {
      save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
      -- when to load the breakpoints? "BufReadPost" is recommanded.
      load_breakpoints_event = "BufReadPost",
      -- load_breakpoints_event = nil,
      -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
      perf_record = false,
      -- perform callback when loading a persisted breakpoint
      -- @param opts DAPBreakpointOptions options used to create the breakpoint ({condition, logMessage, hitCondition})
      -- @param buf_id integer the buffer the breakpoint was set on
      -- @param line integer the line the breakpoint was set on
      on_load_breakpoint = nil,
    },
  },
  { "AndrewRadev/linediff.vim"},
  { "mhinz/vim-grepper" },
  {
    "mangelozzi/rgflow.nvim",
    config = function()
      require("rgflow").setup({
        -- Set the default rip grep flags and options for when running a search via
        -- RgFlow. Once changed via the UI, the previous search flags are used for
        -- each subsequent search (until Neovim restarts).
        cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",
        -- Mappings to trigger RgFlow functions
        default_trigger_mappings = false,
        -- These mappings are only active when the RgFlow UI (panel) is open
        default_ui_mappings = true,
        -- QuickFix window only mapping
        default_quickfix_mappings = true,
        mappings = {
          -- Mappings that all always present
          trigger = {
            -- Normal mode maps
            n = {
              ["<leader>rg"] = "open_blank", -- open UI - search pattern = blank
              ["<leader>rw"] = "open_cword", -- open UI - search pattern = <cword>
            },
            -- Visual/select mode maps
            x = {
              ["<leader>rg"] = "open_visual", -- open UI - search pattern = current visual selection
            },
          },
        },
      })
    end,
  },
  -- Fuzzy Finder (files, lsp, etc)
  { "junegunn/fzf",     build = { ":call fzf#install()" } },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        winopts = {
          preview = {
            vertical = "up:50%",
            -- win_height = 0.8,
            -- win_width = 0.8,
            -- win_row = 0.5,
            -- win_col = 0.5,
          },
        },
        fzf_opts = {
           ["--layout"] = "default",
        },
        on_create = function()
          -- enable register <C-r>", to paste registers in term mode, only for fzf-lua terminals
          vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })
        end,
        lsp = {
          code_actions = {
            previewer = "codeaction_native",
            preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
          },
        },
        -- defaults = { formatter = "path.filename_first" },
      })
    end,
  },
  {
    "princejoogie/chafa.nvim",
    cond = vim.fn.executable("chafa") == 1,
    config = function()
      require("chafa").setup({
        render = {
          min_padding = 5,
          show_label = true,
        },
        events = {
          update_on_nvim_resize = true,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "m00qek/baleia.nvim",
    },
  },
  { "junegunn/fzf.vim" }, -- just for :Maps
  { "nvim-telescope/telescope.nvim",            branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make",   cond = vim.fn.executable("make") == 1 },
  -- { -- vim-rooter to avoid telscope change pwd when grepping or finding files.
  -- Prefer fzf-lua over telescope and don't use vim-rooter. slow.
  --   "airblade/vim-rooter",
  --   config = function()
  --     vim.g.rooter_patterns = { ".git", ".svn", ".hg", ".project", ".root", "package.json", ">site-packages" }
  --   end,
  -- },
  --  DAP: Adaparter configuration for specific languages
  "mfussenegger/nvim-dap-python",
  -- Buffer helpers
  "vim-scripts/BufOnly.vim", -- :BOnly deltes all buffers except current one.
  "moll/vim-bbye",          -- Bdelete, as Bclose, deleting buffers without deleting windows.
  -- File tree

  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.files").setup({
        -- Don't use `h`/`l` for easier cursor navigation during text edit
        mappings = {
          go_in = 'L',
          go_in_plus = '',
          go_out = 'H',
          go_out_plus = '',
        }
      })

      -- set conceallevel 1 in ft=minifiles
      vim.cmd([[
        augroup mini
          autocmd!
          autocmd FileType minifiles setlocal conceallevel=1
        augroup END
      ]])
    end,
    keys = {
      {
        "-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0)) -- open directory of current
        end,
        desc = "Open parent directory",
      },
    },
  },

  -- {
  --   "stevearc/oil.nvim",
  --   config = true,
  --   keys = {
  --     -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  --     {
  --       "-",
  --       function()
  --         require("oil").open_float()
  --       end,
  --       desc = "Open parent directory",
  --     },
  --   }
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED,   handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-vim-test",
      "alfaix/neotest-gtest"
    },
    config = function()
      require("neotest").setup({
        status = {
          virtual_text = true,
        },
        output = {
          enabled = true,
          open_on_run = "short"
        },
        quickfix = {
          enable = true,
          open = function()
          -- if vim.fn.exists(":Trouble") == 2 then
            require("trouble").open({ mode = "quickfix", focus = false })
          -- else
            -- vim.cmd("Trouble quickfix")
          end,
        },

        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
          require("neotest-plenary"),
          require("neotest-gtest").setup({}),
          require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua" },
          }),
        },
      })
    end,
    keys = {
      { '<leader>ta', "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = '[T]est [a]ll' },
      { '<leader>tf', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = '[T]est current [f]ile' },
      { '<leader>tt', "<cmd>lua require('neotest').run.run()<cr>", desc = '[T]est nearest test' },
      { '<leader>tx', "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Stop test' },
      { '<leader>tl', "<cmd>lua require('neotest').run.run_last()<cr>", desc = 'Run last test' },
      { '<leader>tdn',"<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = '[T]est debug nearest test' },
      { '<leader>ts', "<cmd>lua require('neotest').summary.toggle({ enter = true })<cr>", desc = 'toggle summary' },
      { '<leader>to', "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = 'toggle output panel' },
    },
  },

  -- Copilot --
  { "github/copilot.vim",         lazy = false },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      chat.setup({
        debug = false, -- Enable debugging
        -- See Configuration section for rest
        window = {
          layout = 'vertical',
        },
        mappings = {
          reset = {
            insert = '',
            normal = '',
          },
        },
      })
      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- set this if you want to always pull the latest change
  --   opts = {
  --     mappings = {
  --       sidebar = {
  --         -- Do not close with q or ESC please!!
  --         close = {}
  --       },
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- }
})

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    file_ignore_patterns = { -- ignore all files in scratch directory
      "^scratch/",
    },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-q>"] = function(bufnr)
          require("telescope.actions").smart_send_to_qflist(bufnr)
          -- open quickfix list if it's not already open
          if vim.fn.getqflist({ winid = 0 }).winid == 0 then
            vim.cmd([[copen]])
          end
        end,
      },
    },
    preview = {
      -- truncate the previewer if file is too long:
      -- https://github.com/nvim-telescope/telescope.nvim/issues/623
      filesize_hook = function(filepath, bufnr, opts)
        local max_bytes = 10000
        local cmd = { "head", "-c", max_bytes, filepath }
        require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
      end,
    },
  },
  -- extensions = {
  --   fzf = {
  --     fuzzy = true,                    -- false will only do exact matching
  --     override_generic_sorter = false, -- override the generic sorter
  --     override_file_sorter = true,     -- override the file sorter
  --     case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
  --   },
  -- },
})

-- Enable telescope aerial, if installed
pcall(require("telescope").load_extension, "aerial")

-- Enable telescope fzf native, if installed
-- Same but change cwd to current file parent directory
local function fzf_lua_files_current_buffer()
  require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end
local function fzf_lua_live_grep_current_buffer()
  require("fzf-lua").live_grep({ cwd = vim.fn.expand("%:p:h") })
end
pcall(require("telescope").load_extension, "fzf")
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sa", require("fzf-lua").lsp_finder, { desc = "[S]earch LSP" })
vim.keymap.set("n", "<leader>sf", require("fzf-lua").files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sc", fzf_lua_files_current_buffer, { desc = "[S]earch [F]iles [C]urrent" })
vim.keymap.set("n", "<leader><space>", require("fzf-lua").buffers, { desc = "[S]earch Open buffers" })
vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep, { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sv", fzf_lua_live_grep_current_buffer, { desc = "[S]earch Grep Current [V]" })
vim.keymap.set("n", "<leader>sl", require("fzf-lua").grep_last, { desc = "[S]earch [L]ast" })
vim.keymap.set("n", "<leader>sw", require("fzf-lua").grep_cword, { desc = "[S]earch [W]ord" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local methods = vim.lsp.protocol.Methods
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", require("fzf-lua").lsp_code_actions, "[C]ode [A]ction")

  nmap("gd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, "[G]oto [D]efinition")
  nmap("gr", function() require("fzf-lua").lsp_references({ jump_to_single_result = true }) end, "[G]oto [R]eferences")
  nmap("gI", function() require("fzf-lua").lsp_implementations({ jump_to_single_result = true }) end,
    "[G]oto [I]mplementation")
  -- nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition") -- conflict with bwipeout
  -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", require("fzf-lua").lsp_declarations, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--  Pass python venv to mypy for correct type checking
local venv_path = os.getenv('VIRTUAL_ENV')
local py_path = nil
-- decide which python executable to use for mypy
if venv_path ~= nil then
  py_path = venv_path .. "/bin/python"
else
  py_path = vim.g.python3_host_prog
end
local servers_settings = {
  efm = {},
  clangd = {},
  hydra_lsp = {},
  -- gopls = {},
  pyright = {
  	python = {
  		analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
  		},
  	},
  },
  ruff= {
  },
  pylsp = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
        -- type checker
        pylsp_mypy = {
          enabled = true,
          overrides = { "--python-executable", py_path, true },
          report_progress = true,
          live_mode = false
        },
      },
    },
  },
  -- rust_analyzer = {},
  ts_ls = {},
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- -- For ufo folding using lsp
-- capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true
-- }

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers_settings),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers_settings[server_name],
    })
  end,
})

require("lspconfig").ruff.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end
})
-- Change clangd cmd:
require("lspconfig").clangd.setup({
  cmd = { "clangd", "--offset-encoding=utf-16" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = servers_settings.clangd,
})

-- efm language server
-- From: https://github.com/creativenull/efmls-configs-nvim
--
local prettier = require('efmls-configs.formatters.prettier')
local shellcheck = require('efmls-configs.linters.shellcheck')
local shfmt = require('efmls-configs.formatters.shfmt')
local black = require('efmls-configs.formatters.black')
local ruff_format = require('efmls-configs.formatters.ruff')
local ruff_linter = require('efmls-configs.linters.ruff')
local jq = require('efmls-configs.formatters.jq')
local biome = require('efmls-configs.formatters.biome')
local cmake_lint = require('efmls-configs.linters.cmake_lint')

local languages = {
  javascript = { biome },
  javascriptreact = { biome },
  typescript = { biome },
  typescriptreact = { biome },
  -- cpp = { clangd }, -- clangd includes clang-format
  json = { biome, jq },
  css = { prettier },
  scss = { prettier },
  html = { prettier },
  markdown = { prettier },
  yaml = { prettier },
  python = { ruff_format, ruff_linter, black },
  sh = { shfmt, shellcheck },
  bash = { shfmt, shellcheck },
  zsh = { shfmt, shellcheck },
  -- lua = { stylua },
}

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

require('lspconfig').efm.setup(vim.tbl_extend('force', efmls_config, {
  capabilities = capabilities,
  on_attach = on_attach,
}))


-- Turn on lsp status information
require("fidget").setup()

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/vim-snippets", "./lua/snippets" } })


local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = 'nvim_lsp_signature_help' },
    { name = "luasnip" },
    { name = "path" },
    { name = "orgmode" },
    { name = "buffer" },
    { name = "dap" },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
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
    format = lspkind.cmp_format({
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
    }),
  },
  -- From cmp_dap
  -- enabled = function()
  --   return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  -- end,

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = false,
  },
})

-- mini.ai to select functions using tree-sitter
-- From https://github.com/Oliver-Leete/Configs/blob/master/nvim/lua/user/targets.lua
local gen_spec = require("mini.ai").gen_spec
local gen_ai_spec = require('mini.extra').gen_ai_spec

local custom_objects = {
    -- Argument
    a = gen_spec.argument({ separator = "[,;]" }),
    -- Brackets
    b = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
    -- Comments
    -- Digits
    d = gen_ai_spec.number(),
    -- diagnostics
    e = gen_ai_spec.diagnostic(),
    -- Function call
    f = gen_spec.function_call(),
    -- Grammer (sentence)
    g = {
        {
            "%b{}",
            "\n%s*\n()().-()\n%s*\n[%s]*()", -- normal paragraphs
            "^()().-()\n%s*\n[%s]*()",       -- paragraph at start of file
            "\n%s*\n()().-()()$",            -- paragraph at end of file
        },
        {
            "[%.?!][%s]+()().-[^%s].-()[%.?!]()[%s]",   -- normal sentence
            "^[%{%[]?[%s]*()().-[^%s].-()[%.?!]()[%s]", -- sentence at start of paragraph
            "[%.?!][%s]+()().-[^%s].-()()[\n%}%]]?$",   -- sentence at end of paragraph
            "^[%s]*()().-[^%s].-()()[%s]+$",            -- sentence at that fills paragraph (no final punctuation)
        }
    },
    -- Indents
    i = gen_ai_spec.indent(),
    -- Jumps
    -- key (from key value pair)
    k = gen_spec.treesitter({
        i = { "@assignment.lhs", "@key.inner" },
        a = { "@assignment.outer", "@key.inner" },
    }),
    -- List (quickfix)
    -- blOck
    o = gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    -- Paragraph
    p = { {
        "\n%s*\n()().-()\n%s*\n()[%s]*", -- normal paragraphs
        "^()().-()\n%s*\n[%s]*()",       -- paragraph at start of file
        "\n%s*\n()().-()()$",            -- paragraph at end of file
    } },
    -- Quotes
    q = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
    -- sub-woRd (below w on my keyboard)
    r = {
        {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
        },
        "^().*()$"
    },
    -- Scope
    s = gen_spec.treesitter({
        a = { "@function.outer", "@class.outer", "@testitem.outer" },
        i = { "@function.inner", "@class.inner", "@testitem.inner" },
    }),
    -- Tag
    t = { "<(%w-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    -- Value (from key value pair)
    v = gen_spec.treesitter({
        i = { "@assignment.rhs", "@value.inner", "@return.inner" },
        a = { "@assignment.outer", "@value.inner", "@return.outer" },
    }),
    -- WORD
    W = { {
        "()()%f[%w%p][%w%p]+()[ \t]*()",
    } },
    -- word
    w = { "()()%f[%w_][%w_]+()[ \t]*()" },
    -- line (same key as visual line in my mappings)
    x = gen_ai_spec.line(),
    -- chunk (as in from vim-textobj-chunk)
    z = {
            "\n.-%b{}.-\n",
        "\n().-()%{\n.*\n.*%}().-\n()"
    },
    ["$"] = gen_spec.pair("$", "$", { type = "balanced" }),
}

require("mini.ai").setup({
    custom_textobjects = custom_objects,
    mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "{",
        goto_right = "}",
    },
    n_lines = 500,
    search_method = "cover_or_nearest",
})

-- Command Abbreviations, I can't release my shift key fast enough
vim.cmd("cnoreabbrev Q  q")
vim.cmd("cnoreabbrev Qa qa")
vim.cmd("cnoreabbrev W  w")
vim.cmd("cnoreabbrev Wq wq")

vim.cmd.packadd("cfilter")

-- Conditionally load .nvimrc if present in the project directory
-- Allow project-specific vim configuration
vim.opt.secure = true
vim.opt.exrc = true

-- Source local project-specific vim configurations
-- From Reece
local local_vimrc = vim.fn.getcwd()..'/.nvimrc'
local local_vimrclua = vim.fn.getcwd()..'/.nvimrc.lua'
if vim.loop.fs_stat(local_vimrc) then
  vim.cmd('source '..local_vimrc)
end
if vim.loop.fs_stat(local_vimrclua) then
  vim.cmd('luafile '..local_vimrclua)
end

-- Expand 'grp' into 'CodeCompanion' in the command line
vim.cmd([[cab gg GrepperRg]])

-- Map to reformat 'typedef' to 'using' (c++11)
vim.cmd([[
let @t = "^dwf;bde^iusing \<c-R>\" = \e:s/\\s*;/;/g\<C-m>"
]])
vim.cmd'colorscheme kanagawa'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
