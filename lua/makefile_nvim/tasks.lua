local M = {}

-- Parse Makefile for tasks and descriptions
function M.get_tasks()
  local tasks = {}
  local file = io.open("Makefile", "r")
  if not file then
    vim.notify("No Makefile found in the current directory.", vim.log.levels.ERROR)
    return tasks
  end

  for line in file:lines() do
    -- Match tasks with the pattern `target: ## description`
    local target, desc = line:match("^(%w+):.*## (.+)$")
    if target and desc then
      table.insert(tasks, { name = target, description = desc })
    end
  end

  file:close()
  return tasks
end

-- Run a selected task and capture logs
function M.run_task(task_name, on_log_line)
  local cmd = { "make", task_name }
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  -- Run the Makefile target
  local handle, pid = vim.loop.spawn(cmd[1], {
    args = { unpack(cmd, 2) },
    stdio = { nil, stdout, stderr },
    cwd = vim.fn.getcwd(), -- Run in the current working directory
  }, function()
    stdout:close()
    stderr:close()
  end)

  if not handle then
    vim.notify("Failed to run task: " .. task_name, vim.log.levels.ERROR)
    return
  end

  -- Read logs from stdout
  vim.loop.read_start(stdout, function(err, data)
    if data then on_log_line(data) end
  end)

  -- Read logs from stderr
  vim.loop.read_start(stderr, function(err, data)
    if data then on_log_line(data) end
  end)
end

return M
