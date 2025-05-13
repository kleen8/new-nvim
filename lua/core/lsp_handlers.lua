-- lua/core/lsp_handlers.lua  (new tiny file)
local M = {}

function M.jump_first(err, result, ctx, _)
  if err then return vim.notify(err.message, vim.log.levels.ERROR) end
  if not result or vim.tbl_isempty(result) then
    return vim.notify("No definition found", vim.log.levels.INFO)
  end

  local target = (vim.tbl_islist(result) and result[1]) or result
  vim.lsp.util.jump_to_location(target, "utf-8", true)  -- reuse_win = true
end

return M

