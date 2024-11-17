-- lua/makefile_nvim/init.lua
local M = {}

-- Function to set up the plugin (called from the plugin configuration)
function M.setup()
  -- Define commands, keymaps, or anything needed for plugin setup
  vim.api.nvim_create_user_command("MakefileUI", function()
    -- Ensure the UI module is correctly required and the function is available
    require("makefile_nvim.ui").show_makefile_ui()
  end, {})
end

-- Function to create the UI layout
function M.create_ui()
  -- Create two vertical splits for task list and logs
  vim.cmd("vsplit") -- Create the vertical split for tasks
  local task_buf = vim.api.nvim_get_current_buf()

  -- Set up the task list buffer
  vim.api.nvim_buf_set_name(task_buf, "Makefile Tasks")
  vim.api.nvim_buf_set_option(task_buf, 'modifiable', false) -- Make it read-only

  -- Create the log window on the right
  vim.cmd("vsplit") -- Create the vertical split for logs
  local log_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(log_buf, "Task Logs")
  vim.api.nvim_buf_set_option(log_buf, 'modifiable', true) -- Allow modifying log buffer

  -- Set borders for the windows (left and right)
  vim.api.nvim_win_set_option(0, "winborder", "both") -- For the current window (task list)
  vim.api.nvim_win_set_option(1, "winborder", "both") -- For the log window

  -- Focus the cursor on the task list window
  vim.api.nvim_set_current_win(task_buf)
  vim.api.nvim_win_set_cursor(task_buf, { 1, 0 }) -- Move the cursor to the first line in task list

  -- Return buffers for later use
  return task_buf, log_buf
end

-- Function to populate tasks in the task buffer
function M.populate_tasks(task_buf, tasks)
  local lines = {}

  -- Iterate over the tasks and format them as strings
  for _, task in ipairs(tasks) do
    -- Adjust the space between task name and description (using 20 spaces instead of 30)
    local task_line = string.format("%-20s  %s", task.name, task.description)
    table.insert(lines, task_line)
  end

  -- Set the lines in the task buffer
  vim.api.nvim_buf_set_lines(task_buf, 0, -1, false, lines)
end

-- Function to display logs in the log buffer
function M.display_logs(log_buf, log_line)
  -- Display log message in the log buffer
  local current_lines = vim.api.nvim_buf_get_lines(log_buf, 0, -1, false)
  table.insert(current_lines, log_line)
  vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, current_lines)
end

return M
