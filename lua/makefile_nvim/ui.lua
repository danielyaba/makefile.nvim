local M = {}

-- Create split windows for tasks and logs
function M.create_ui()
  vim.cmd("vsplit")
  local task_buf = vim.api.nvim_create_buf(false, true)
  local log_buf = vim.api.nvim_create_buf(false, true)

  local win_task = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win_task, task_buf)

  vim.cmd("wincmd l")
  local win_log = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win_log, log_buf)

  vim.api.nvim_buf_set_option(task_buf, "filetype", "makefile_nvim_tasks")
  vim.api.nvim_buf_set_option(log_buf, "filetype", "makefile_nvim_logs")

  return task_buf, log_buf, win_task, win_log
end

-- Populate task list with descriptions
function M.populate_tasks(task_buf, tasks)
  local lines = {}
  for _, task in ipairs(tasks) do
    table.insert(lines, string.format("%-15s %s", task.name, task.description))
  end
  vim.api.nvim_buf_set_lines(task_buf, 0, -1, false, lines)
end

-- Append log lines to the log buffer
function M.display_logs(log_buf, log_line)
  vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, { log_line })
end

return M
