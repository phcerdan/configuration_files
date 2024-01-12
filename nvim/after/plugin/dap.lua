-- Explore:
-- - External terminal
-- - make the virt lines thing available if ppl want it
-- - find the nearest codelens above cursor

-- Must Show:
-- - Connect to an existing neovim instance, and step through some plugin
-- - Connect using configuration from VS **** json file (see if VS **** is actually just "it works" LUL)
-- - Completion in the repl, very cool for exploring objects / data

-- - Generating your own config w/ dap.run (can show rust example) (rust BTW)

local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

-- when to stop on exception (uncaught is providing post mortem debugging) (see dap-api)
dap.set_exception_breakpoints({"raised", "uncaught"})


vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg='#993939', bg='#31353f'})
vim.api.nvim_set_hl(0, 'DapGreen', { ctermbg = 0, fg='#9ece6a'})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "ü", texthl = "DapBreakpoint", linehl = "", numhl = "" })
-- Setup cool Among Us as avatar
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapGreen" })

require("nvim-dap-virtual-text").setup {
  enabled = true,

  -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
  enabled_commands = false,

  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  highlight_new_as_changed = true,

  -- prefix virtual text with comment string
  commented = false,

  show_stop_reason = true,

  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
}

-- lua
dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host, port = config.port }
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      return "127.0.0.1"
    end,
    port = function()
      -- local val = tonumber(vim.fn.input('Port: '))
      -- assert(val, "Please provide a port number")
      local val = 54231
      return val
    end,
  }
}

local last_program = nil
local last_module = nil
local last_args = nil
local last_file_args = nil
-- python
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch current file from current working directory",
    cwd = vim.fn.getcwd(),
    program = "${file}",
    args = function()
      local args_string = vim.fn.input('Arguments: ', last_args or '')
      return vim.split(args_string, " +")
    end,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch command from current working directory",
    cwd = vim.fn.getcwd(),
    program = function()
      local args_string = vim.fn.input('Script to launch: ', last_program or '')
      return args_string
    end,
    args = function()
      local args_string = vim.fn.input('Arguments: ', last_args or '')
      return vim.split(args_string, " +")
    end,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch command from current working directory, using a file for arguments",
    cwd = vim.fn.getcwd(),
    program = function()
      local args_string = vim.fn.input('Script to launch: ', last_program or '')
      return args_string
    end,
    args = function()
      local file_path = vim.fn.input('Arguments File: ', last_file_args or '')
      -- Read the file, each argument on a new line
      local args = {}
      for line in io.lines(file_path) do
        table.insert(args, line)
      end
      return args
    end,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch module from current working directory",
    cwd = vim.fn.getcwd(),
    module = function()
      local args_string = vim.fn.input('Module to launch: ', last_module or '')
      return args_string
    end,
    args = function()
      local args_string = vim.fn.input('Arguments: ', last_args or '')
      return vim.split(args_string, " +")
    end,
    console = "integratedTerminal",
  },
  {
    -- https://github.com/mfussenegger/nvim-dap/wiki/Local-and-Remote-Debugging-with-Docker
    -- https://github.com/mfussenegger/nvim-dap-python/issues/75
    -- In docker-compose file add:
    --[[
    ports
     - "5678:5678"
     security_opt:
       - seccomp:unconfined
     cap_add:
       - SYS_PTRACE
    --]]
    -- If using docker compose run, instead of up, we need the flag: --service-ports
    -- docker compose -f docker-compose.yaml run --service-ports {service} bash
    -- In the docker container run:
    --   python -m debugpy --listen 0.0.0.0:5678 --wait-for-client app.py
    type = 'python',
    request = 'attach',
    connect = {
      host = "127.0.0.1",
      port = 5678, -- debug port
    },
    mode = "remote",
    name = 'Remote Attached Debugger',
    cwd = vim.fn.getcwd(),
    pathMappings = {
      {
        localRoot = function()
          return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
        end,
        remoteRoot = function()
          return vim.fn.input("Container code folder > ", "/", "file")
        end,
      },
    },
    console = "integratedTerminal",
  },
}

local dap_python = require "dap-python"
dap_python.setup(vim.g.python3_host_prog, {
  -- So if configured correctly, this will open up new terminal.
  --    Could probably get this to target a particular terminal
  --    and/or add a tab to kitty or something like that as well.
  -- console = "externalTerminal",

  include_configs = true,
})

local configurations_python = require('dap').configurations.python
for _, configuration in pairs(configurations_python) do
  -- Allow to step into external libraries
  configuration.justMyCode = false
  -- Allow to stop at breakpoints ok. see https://github.com/mfussenegger/nvim-dap/issues/362
  configuration.subProcess = false
end

dap_python.test_runner = "pytest"

-- rust
dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

dap.adapters.codelldb = {
  type = 'server',
  port = "13000",
  executable = {
    command = 'codelldb',
    args = { "--port", "13000" },
  }
}

-- cpp
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    -- program = function()
    --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    -- end,
    program = function()
      return vim.fn.input('Path to executable: ', vim.api.nvim_get_var('buildFolder'), 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local s = vim.fn.input('Args: ', vim.api.nvim_get_var('debugArgs'), 'file')
      -- Split by whitespaces
      local split_args = {}
      for arg in s:gmatch("%S+") do table.insert(split_args, arg) end
      return split_args
    end,
    -- To inherit all environment variables
    env = function()
       local variables = {}
       for k, v in pairs(vim.fn.environ()) do
         table.insert(variables, string.format("%s=%s", k, v))
       end
       return variables
     end,
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}
-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


local map = function(lhs, rhs, desc)
  if desc then
    desc = "[DAP] " .. desc
  end

  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<F4>", function() require("dapui").toggle({ reset = true }) end, "dapui-toggle")

map("<F5>", require("dap").continue, "continue")
-- map("<S-F5>", require("dap").terminate, "terminate")
map("<F17>", require("dap").terminate, "terminate") -- F13-F24
-- map("<C-S-F5>", require("dap").restart, "restart")
map("<F41>", require("dap").restart, "restart") -- F37-F48
map("<F6>", require("dap").up, "up frame")
-- map("<S+F6>", require("dap").down, "down frame")
map("<F18>", require("dap").down, "down frame")
map("<F7>", require("dap").run_to_cursor, "run_to_cursor")
-- map("<F8>", require("dap").step_back, "step_back")
map("<F9>", require("dap").toggle_breakpoint, "toggle_breakpoint")
map("<F10>", require("dap").step_over, "step_over")
map("<F11>", require("dap").step_into, "step_into")
-- map("<S-F11>", require("dap").step_out, "step_out")
map("<F23>", require("dap").step_out, "step_out")

-- TODO:
-- disconnect vs. terminate

map("<leader>dr", require("dap").repl.open)
map("<leader>db", require("dap").toggle_breakpoint)
map("<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
end)

map("<leader>dm", function()
 require("dap-python").test_method({config = {justMyCode = false, subProcess = false}})
 end)

map("<leader>de", require("dapui").eval)
map("<leader>dE", function()
  require("dapui").eval(vim.fn.input "[DAP] Expression > ")
end)

map("<leader>dh", require('dap.ui.widgets').hover, "dapui hover")
-- Close dap-float with q
vim.cmd [[
autocmd FileType dap-float nnoremap <buffer><silent> q <cmd>close!<CR>
]]

local dap_ui = require "dapui"

local _ = dap_ui.setup {
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
  -- -- You can change the order of elements in the sidebar
  -- sidebar = {
  --   elements = {
  --     -- Provide as ID strings or tables with "id" and "size" keys
  --     {
  --       id = "scopes",
  --       size = 0.75, -- Can be float or integer > 1
  --     },
  --     { id = "watches", size = 00.25 },
  --   },
  --   size = 50,
  --   position = "left", -- Can be "left" or "right"
  -- },
  --
  -- tray = {
  --   elements = {},
  --   size = 15,
  --   position = "bottom", -- Can be "bottom" or "top"
  -- },
}


-- Run last: https://github.com/mfussenegger/nvim-dap/issues/1025
local last_config = nil
---@param session Session
dap.listeners.after.event_initialized["store_config"] = function(session)
  last_config = session.config
end

local function debug_run_last()
  if last_config then
    dap.run(last_config)
  else
    dap.continue()
  end
end

vim.keymap.set('n', '<Leader>dl', function()
    debug_run_last()
end,
{ silent = true, desc = "[DAP] Run last" }
)

