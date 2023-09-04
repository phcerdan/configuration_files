-- Use a pynvim virtual env to avoid having to install pynvim every time.
-- See help python-virtualenv
-- Or install it in system python
local pynvim_path="/usr/bin/python3"
vim.g.python3_host_prog = vim.fn.expand(pynvim_path)
