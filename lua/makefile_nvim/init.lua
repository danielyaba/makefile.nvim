local tasks = require("makefile_nvim.tasks")
local ui = require("makefile_nvim.ui")

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("MakefileUI", function()
    -- Set up the full window layout
    vim.cmd("tabnew")   -- Open a new tab to ensure we're working in a clean environment
    vim.cmd("wincmd _") -- Maximize the window vertically
    vim.cmd("wincmd |") -- Maximize the window horizontally

    -- Create the two splits
    local task_buf, log_buf = ui.create_ui()

    -- Fetch and display tasks
    local makefile_tasks = tasks.get_tasks()
    if #makefile_tasks == 0 then
      vim.notify("No tasks found in Makefile.", vim.log.levels.WARN)
      return
    end
    ui.populate_tasks(task_buf, makefile_tasks)

    -- Set keymap for task execution in the tasks buffer
    vim.api.nvim_buf_set_keymap(task_buf, "n", "<CR>", "", {
      noremap = true,
      silent = true,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local task_name = line:match("^(%w+)")
        if task_name then
          vim.notify("Running task: " .. task_name, vim.log.levels.INFO)
          tasks.run_task(task_name, function(log_line)
            ui.display_logs(log_buf, log_line)
          end)
        else
          vim.notify("Invalid task selection.", vim.log.levels.ERROR)
        end
      end,
    })
  end, {
    desc = "Open the Makefile UI for task execution",
  })
end

return M
