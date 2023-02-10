vim.api.nvim_set_keymap("n", "<leader>d", ":Bwipeout<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>nn", ":NvimTreeToggle<CR>", {noremap = true})
vim.api.nvim_command("cnoremap zc e <c-r>=expand('%:h')<cr>/")

-- Slime
vim.g["slime_target"] = "tmux"
vim.g["slime_python_ipython"] = 1
vim.api.nvim_create_user_command("TmuxSockets", 'silent! !lsof -U | grep "^tmux"', {bang=true})

-- barbar buffer
vim.cmd[[
let g:bufferline.icons = "both"
]]
