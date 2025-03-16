vim.keymap.set("i", "<C-c>", "<Esc>")
vim.cmd([[
	au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
	au FileType fzf tunmap <buffer> <Esc>
]])

vim.api.nvim_set_keymap("n", "<leader>d", ":Bwipeout<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>D", ":Bwipeout!<CR>", { noremap = true })
vim.api.nvim_command("cnoremap zc e <c-r>=expand('%:h')<cr>/")

-- Tab navigation
vim.g.lasttab = 1
vim.keymap.set("n", "<leader>t", function()
	vim.cmd.tabn(vim.g.lasttab)
end)
vim.cmd([[
au TabLeave * let g:lasttab = tabpagenr()
]])

-- Slime
vim.g["slime_target"] = "tmux"
vim.g["slime_python_ipython"] = 1
vim.api.nvim_create_user_command("TmuxSockets", 'silent! !lsof -U | grep "^tmux"', { bang = true })

-- refactoring
-- prompt for a refactor to apply when the remap is triggered
vim.api.nvim_set_keymap(
	"v",
	"<leader>fr",
	":lua require('refactoring').select_refactor()<CR>",
	{ noremap = true, silent = true, expr = false }
)

------------ end refactoring ---------------

-- git-messenger
vim.g["git_messenger_no_default_mappings"] = "true"
vim.api.nvim_set_keymap("n", "<leader>m", "<Plug>(git-messenger)", { noremap = true })

-- copilot
-- From: https://github.com/hrsh7th/nvim-cmp/issues/459
-- keep the tab map, but provide an alternative way to accept the completion
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-\\>", "copilot#Accept('<CR>')", { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-]>", "copilot#Next()", { silent = true, expr = true })

-- jupytext
vim.g.jupytext_fmt = "py"
vim.g.jupytext_command = vim.g.python3_host_prog .. " -m jupytext"

-- fugitive
-- create user command Gl to open fugitive log with --decorate
vim.api.nvim_command("command! Gl :Git log --decorate")

-- grepper current word
vim.cmd([[
nnoremap <leader>ss :GrepperRg <C-r><C-w>
]])

vim.cmd([[
" Don't move when pressing * (highlight current word)
" Also use g* instead of *, to avoid searching for whole words.

" whole words brackets \<, \>
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
nnoremap <silent> g* :let stay_star_view = winsaveview()<cr>g*:call winrestview(stay_star_view)<cr>
]])

-- Maps, prefer use LfzLua
vim.api.nvim_command("command! Maps :FzfLua keymaps")

-- magma: https://github.com/dccsillag/magma-nvim
vim.cmd([[
nnoremap <silent><expr> <leader>m  :MagmaEvaluateOperator<CR>
nnoremap <silent>       <leader>mm :MagmaEvaluateLine<CR>
xnoremap <silent>       <leader>m  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <leader>mc :MagmaReevaluateCell<CR>
nnoremap <silent>       <leader>md :MagmaDelete<CR>
nnoremap <silent>       <leader>mo :MagmaShowOutput<CR>
]])

vim.g.magma_automatically_open_output = false
vim.g.magma_image_provider = "kitty"
---

-- Undofile {{{
vim.o.undofile = true -- Maintain a undofile to keep changes between sessions.
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"
-- }}}

-- Resize windows {{{
vim.keymap.set("n", "<c-Right>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<c-Left>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<c-Up>", ":resize +5<CR>")
vim.keymap.set("n", "<c-Down>", ":resize -5<CR>")
-- }}}
