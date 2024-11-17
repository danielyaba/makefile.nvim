-- plugin/makefile_nvim.lua
local M = {}

function M.setup()
  -- Your plugin setup code goes here
  -- For example: defining commands, keymaps, or anything related to setting up the plugin
  vim.api.nvim_create_user_command("MakefileUI", function()
    require("makefile_nvim.ui").show_makefile_ui()
  end, {})
end

return M
