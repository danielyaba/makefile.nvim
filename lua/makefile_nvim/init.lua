local tasks = require("makefile_nvim.tasks")
local ui = require("makefile_nvim.ui")

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("MakefileUI", function()
    -- Create the general border and the two inner splits
    local task_buf, log_buf, task_win, log_win = ui.create_ui()

    -- Fetch and display tasks
    local makefile_tasks = tasks.get_tasks()
    if #makefile_tasks == 0 then
      vim.notify("No tasks found in Makefile.", vim.log.levels.WARN)
      return
    end
    ui.populate_tasks(task_buf, makefile_tasks)

    -- Keymap to quit the UI with 'q' or 'ESC'
    vim.api.nvim_buf_set_keymap(task_buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(log_buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(task_buf, "n", "<ESC>", ":q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(log_buf, "n", "<ESC>", ":q<CR>", { noremap = true, silent = true })

    -- Keymap to execute a task
    vim.api.nvim_buf_set_keymap(task_buf, "n", "<CR>", "", {
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local task_name = line:match("^(%w+)")
        if task_name then
          tasks.run_task(task_name, function(log_line)
            ui.display_logs(log_buf, log_line)
          end)
        end
      end,
    })
  end, {})
end

return M
