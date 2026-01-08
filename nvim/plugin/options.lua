local opt = vim.opt

opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.mouse = "a" -- Enable mouse mode
opt.breakindent = true -- Enable break indent
opt.updatetime = 50 -- Decrease update time
opt.signcolumn = "yes"

-- Searching {{{
opt.gdefault = true -- avoid to /g at the end of search.
opt.ignorecase = true -- ignore case
opt.smartcase = true -- except when there is a case on the query
opt.hlsearch = true -- highlight search
opt.incsearch = true -- incremental search
opt.scrolloff = 20 -- Make it so
-- }}}
-- Set completeopt to have a better completion experience
opt.completeopt = 'menuone,noselect,preview'

-- Ignore compiled files
opt.wildignore = "__pycache__"
opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*" }
opt.wildignore:append "Cargo.lock"

-- Cool floating window popup menu for completion on command line
opt.pumblend = 17
opt.wildmode = "longest:full"
opt.wildoptions = "pum"
opt.inccommand = "split"

local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")

-- Backup
opt.backup = true
-- Where to store backups, the folder must be created beforehand
opt.backupdir = { prefix .. "/nvim/backup/" }
-- Make backup before overwriting the current buffer
opt.writebackup = true
--  Overwrite the original backup file
opt.backupcopy = "yes"
opt.backupext = ".bak"
opt.backupskip = "/tmp/*,/private/tmp/*"

-- Undofile
opt.undofile = true -- Maintain a undofile to keep changes between sessions.
opt.undodir = { prefix .. "/nvim/undo//" }

-- Tabs
opt.autoindent = true
opt.cindent = true
opt.wrap = true
opt.smartindent = true
opt.colorcolumn = "81"

-- Indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true

opt.splitright = true -- Prefer split right
opt.splitbelow = true -- Prefer split bottom
opt.timeoutlen = 500 -- timeoutlen : time to wait for chain character (leader, etc) Default is 1000, 1 sec
opt.hidden = true -- Buffers stay around

-- Cursorline highlighting control
--  Only have it on in the active buffer
opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")


-- opt.foldmethod = "marker"
-- opt.foldlevel = 0 # Set already in nvim-ufo plugin
opt.modelines = 1
opt.laststatus = 3

opt.fixendofline = false -- Don't add a newline at the end of the file
opt.diffopt:append("vertical") -- Gdiff open in vertical.

opt.clipboard = "unnamedplus" -- Use system clipboard

-- From https://github.com/neovim/neovim/discussions/28010#discussioncomment-9877494
-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- -- From :h clipboard-osc52
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     -- ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--     ['+'] = paste,
--     ['*'] = paste,
--   },
-- }

-- vim.g.clipboard = {
--     name = "tmux",
--     copy = {
--         ["+"] = { "tmux", "load-buffer", "-" },
--         ["*"] = { "tmux", "load-buffer", "-" },
--     },
--     paste = {
--         ["+"] = { "tmux", "save-buffer", "-" },
--         ["*"] = { "tmux", "save-buffer", "-" },
--     },
-- }
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     group = vim.api.nvim_create_augroup("osc52", { clear = true }),
--     callback = function()
--         if vim.v.operator == "y" then
--             local text = vim.fn.getreg("+")
--             local lines = vim.split(text, "\n")
--             require("vim.ui.clipboard.osc52").copy("+")(lines)
--         end
--     end,
-- })
--

-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }
