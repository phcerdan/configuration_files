vim.api.nvim_set_keymap("n", "<leader>d", ":Bwipeout<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>nn", ":NvimTreeToggle<CR>", { noremap = true })
vim.api.nvim_command("cnoremap zc e <c-r>=expand('%:h')<cr>/")

-- Slime
vim.g["slime_target"] = "tmux"
vim.g["slime_python_ipython"] = 1
vim.api.nvim_create_user_command("TmuxSockets", 'silent! !lsof -U | grep "^tmux"', { bang = true })

-- barbar buffer
vim.cmd [[
let g:bufferline.icons = "both"
]]

-- refactoring
-- prompt for a refactor to apply when the remap is triggered
vim.api.nvim_set_keymap(
	"v",
	"<leader>rr",
	":lua require('refactoring').select_refactor()<CR>",
	{ noremap = true, silent = true, expr = false }
)
-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.api.nvim_set_keymap(
	"n",
	"<leader>rp",
	":lua require('refactoring').debug.printf({below = false})<CR>",
	{ noremap = true }
)
-- Print var
-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
vim.api.nvim_set_keymap("n", "<leader>rv", ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
	{ noremap = true })
-- Remap in visual mode will print whatever is in the visual selection
vim.api.nvim_set_keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

-- Cleanup function: this remap should be made in normal mode
vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })

------------ end refactoring ---------------

-- git-messenger
vim.g["git_messenger_no_default_mappings"] = "true"
vim.api.nvim_set_keymap("n", "<leader>m", "<Plug>(git-messenger)", { noremap = true })

-- folke/trouble.nvim
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
	{ silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
	{ silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
	{ silent = true, noremap = true })

-- harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", harpoon_mark.add_file)
vim.keymap.set("n", "<C-e>", harpoon_ui.toggle_quick_menu)
vim.keymap.set("n", "<C-n>", function() harpoon_ui.nav_next() end)
vim.keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end)
