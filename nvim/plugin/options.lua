local opt = vim.opt

opt.mouse = "a" -- Automatic enable mouse

-- Searching {{{
opt.gdefault = true   -- avoid to /g at the end of search.
opt.ignorecase = true -- ignore case
opt.smartcase = true  -- except when there is a case on the query
opt.hlsearch = true   -- highlight search
opt.incsearch = true  -- incremental search
opt.scrolloff = 20    -- Make it so
-- }}}


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
opt.backupdir = { prefix .. "/nvim/backup//" }
-- Make backup before overwriting the current buffer
opt.writebackup = true
--  Overwrite the original backup file
opt.backupcopy = "yes"
opt.backupext = ".bak"
opt.backupskip="/tmp/*,/private/tmp/*"

-- Undofile
opt.undofile = true  -- Maintain a undofile to keep changes between sessions.
opt.undodir= { prefix .. "/nvim/undo//" }

-- Tabs
opt.autoindent = true
opt.cindent = true
opt.wrap = true

-- Indent
opt.tabstop=4
opt.shiftwidth=4
opt.softtabstop=4
opt.expandtab=true

opt.splitright = true -- Prefer split right
opt.splitbelow = true -- Prefer split bottom
opt.timeoutlen=500 -- timeoutlen : time to wait for chain character (leader, etc) Default is 1000, 1 sec
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


opt.foldmethod = "marker"
opt.foldlevel = 0
opt.modelines = 1

opt.updatetime=300 -- CursorHold related time, default to 4000ms
