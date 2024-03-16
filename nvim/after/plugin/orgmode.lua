-- From Reece: https://github.com/ReeceStevens/config-files/blob/master/vim/config/orgmode-config.lua
-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = {"~/notes/org-notes/*.org"},
  org_default_notes_file = '~/notes/org-notes/refile.org',
  org_todo_keywords = {'TODO', 'IN_PROGRESS', 'BLOCKED', 'DONE'},
  org_capture_templates = {
    t = { description = 'Task', template = '** TODO %?\n  %u' },
    m = {
      description = 'Meeting',
      template = '* %?\n  %u\n\n** Notes\n\n\n** Action Items\n\n\n' }
  },
  org_startup_indented = false,
  org_todo_keyword_faces = {
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
    IN_PROGRESS = ':foreground orange', -- overrides builtin color for `TODO` keyword
    DONE = ':foreground green :weight bold', -- overrides builtin color for `TODO` keyword
  },
  calendar_week_start_day = 0,
})

vim.api.nvim_set_hl(0, 'OrgAgendaDeadline', {link = 'Error'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduled', {link = 'Function'})
vim.api.nvim_set_hl(0, 'OrgAgendaScheduledPast', {link = 'DiagnosticWarn'})
vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#1B1D1F"})

-- To conceal org hyperlinks, which can be somewhat verbose
--autocmd BufRead,BufNewFile *.txt setfiletype text
vim.api.nvim_create_autocmd(
    {"BufRead", "BufNewFile"}, {
        pattern = {"*.org"},
        command = "setlocal conceallevel=1",
    }
)
vim.opt.conceallevel = 1
