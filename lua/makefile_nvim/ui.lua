local M = {}

-- Function to create the UI
M.create_ui = function()
  -- Create a vertical split for tasks and a horizontal split for logs
  vim.cmd("vsplit") -- Create vertical split for task list
  local task_buf = vim.api.nvim_get_current_buf()
  vim.cmd("split")  -- Create horizontal split for logs
  local log_buf = vim.api.nvim_get_current_buf()

  -- Resize the splits to maximize them
  vim.cmd("wincmd _") -- Maximize the log window vertically
  vim.cmd("wincmd |") -- Maximize the task window horizontally

  -- Set the task buffer to be the left window and the log buffer to be the right window
  return task_buf, log_buf
end

-- Function to populate tasks in the task buffer
M.populate_tasks = function(buf, tasks)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  for _, task in ipairs(tasks) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { task.name .. " - " .. task.description })
  end
end

-- Function to display logs in the log buffer

M.display_logs = function(buf, log_line)
  vim.schedule(function() -- Schedule this update to avoid the callback issue
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { log_line })
    vim.cmd("normal! G")  -- Scroll to the bottom of the log window
  end)
end

return M
