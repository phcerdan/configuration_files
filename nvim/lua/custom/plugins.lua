return function(use)
  use(
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup({})
      end
    })
  use {"ellisonleao/gruvbox.nvim"} -- Colorscheme, config needs to be done in init.lua
  use {"christoomey/vim-tmux-navigator"} -- Navigate vim/tmux with same keys: <c-hjkl>
  use {"jpalardy/vim-slime"} -- Send/Copy from vim to other tmux pane
  use {"ntpeters/vim-better-whitespace"} -- Highlight whitespaces and provide StripWhiteSpaces()
  use {"junegunn/gv.vim"} --:GV for commit browser, GV! for one this file, GV? fills location list.
  use {"shumphrey/fugitive-gitlab.vim" } -- Gbrowse works in gitlab
  use {"tpope/vim-obsession"} -- Save sessions :Obsess, Restore vim -S. Also used by tmux-resurrect
  use {"tpope/vim-abolish"} -- Subsitutions with plurals, cases, etc.
  use {"tpope/vim-unimpaired"} -- Add ][q (cnext), ][b (bnext), ][Space (add new lines)
  use {"wsdjeg/vim-fetch"} -- Enable opening files with format: vim file_name.xxx:line,col
  use {"vim-scripts/restore_view.vim"} -- Restore file position and FOLDS.
  use {"rhysd/vim-clang-format"} -- :ClangFormat
  -- Asyncrun
  use {'skywind3000/asyncrun.vim'} -- async :! command, read output using error format, or use % raw to ignore.
  use {'powerman/vim-plugin-AnsiEsc'} -- For escaping terminal colors in vim
  use {'mh21/errormarker.vim'} -- " errormarker to display errors of asyncrun , https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
  use {'nvim-tree/nvim-web-devicons'}
  -- Completion --
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-nvim-lua" }
  use { "onsails/lspkind-nvim" }
  use { "tamago324/cmp-zsh" }
  -- DAP (Debug Adapter Protocol) --
  use {'mfussenegger/nvim-dap'}
  use {"rcarriga/nvim-dap-ui"}
  use {"rcarriga/cmp-dap"} -- nvim-cmp soruce for nvim-dap REPL and nvim-dap-ui buffers
  use {'theHamsta/nvim-dap-virtual-text',
  config = function()
    require('nvim-dap-virtual-text').setup()
  end
  }
  use {"nvim-telescope/telescope-dap.nvim"}
  --  DAP: Adaparter configuration for specific languages
  use { "mfussenegger/nvim-dap-python" }
  -- Buffer helpers
  use {'vim-scripts/BufOnly.vim'} -- :BOnly deltes all buffers except current one.
  use {'moll/vim-bbye'} -- Bdelete, as Bclose, deleting buffers without deleting windows.
  use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}
  -- File tree
  use { 'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      require("nvim-tree").setup()
    end
  }
  -- Copilot --
  use { "github/copilot.vim" }
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
  use { "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        -- optional configuration
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }
end
