local M = {}

M.cycle_down_or_wrap = function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)

    if current_line == total_lines then
        -- Go to the first line if on the last line
        vim.api.nvim_win_set_cursor(0, {1, 0})
    else
        -- Move down one line
        vim.api.nvim_win_set_cursor(0, {current_line + 1, 0})
    end
end

return M
