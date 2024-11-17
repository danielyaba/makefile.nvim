local M = {}

-- Ensure the setup function exists in the init.lua module
function M.setup()
  -- Call the setup function from init.lua
  require("makefile_nvim").setup()
end

return M
