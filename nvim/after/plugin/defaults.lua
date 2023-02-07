vim.api.nvim_set_keymap("n", "<leader>d", ":Bwipeout<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>nn", ":NvimTreeToggle<CR>", {noremap = true})
vim.api.nvim_command("cnoremap zc e <c-r>=expand('%:h')<cr>/")
