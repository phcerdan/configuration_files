-- Use a pynvim virtual env to avoid having to install pynvim every time.
-- See help python-virtualenv
-- Or install it in system python
-- local pynvim_path="/usr/bin/python3"
local pynvim_path="~/.virtualenvs/magma/bin/python3"
vim.g.python3_host_prog = vim.fn.expand(pynvim_path)

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
