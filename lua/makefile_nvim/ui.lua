local M = {}

-- Function to create the UI with two splits and borders
M.create_ui = function()
  -- Create a new buffer for tasks and logs
  local task_buf = vim.api.nvim_create_buf(false, true)
  local log_buf = vim.api.nvim_create_buf(false, true)

  -- Create the general window
  local general_win = vim.api.nvim_open_win(task_buf, true, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    border = "single", -- Single border around the whole window
  })

  -- Create the task window (left split)
  local task_win = vim.api.nvim_open_win(task_buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns / 2), -- Half the screen width
    height = vim.o.lines - 2,              -- Reduce height for the border
    row = 0,
    col = 0,
    border = "double", -- Double border for the tasks window
  })

  -- Create the log window (right split)
  local log_win = vim.api.nvim_open_win(log_buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns / 2), -- Half the screen width
    height = vim.o.lines - 2,              -- Same height as tasks window
    row = 0,
    col = math.floor(vim.o.columns / 2),   -- Position it to the right
    border = "double",                     -- Double border for the logs window
  })

  -- Return the task and log buffers and windows for future configuration
  return task_buf, log_buf, task_win, log_win
end

-- Function to populate the task list in the left split
function M.populate_tasks(task_buf, tasks)
  -- Ensure tasks is a list of strings
  local lines = {}

  -- Iterate over the tasks and format them as strings
  for _, task in ipairs(tasks) do
    -- Make sure each task is a string, including its description
    local task_line = string.format("%-30s  %s", task.name, task.description)
    table.insert(lines, task_line)
  end

  -- Set the lines in the task buffer
  vim.api.nvim_buf_set_lines(task_buf, 0, -1, false, lines)
end

-- Function to display the logs in the right split
M.display_logs = function(buf, log_line)
  vim.schedule(function()
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { log_line })
    vim.cmd("normal! G") -- Scroll to the bottom of the log window
  end)
end

return M
