local M = {}

local prettier_config = {}

-- conform condition: prettier runs only where it finds a config for the file
function M.prettier_has_config(_, ctx)
  if prettier_config[ctx.dirname] == nil then
    local out = vim.system({ "prettier", "--find-config-path", ctx.filename }):wait()
    prettier_config[ctx.dirname] = out.code == 0
  end
  return prettier_config[ctx.dirname]
end

-- Whether format on save is on for the buffer
function M.enabled(bufnr)
  local b = vim.b[bufnr].autoformat
  if b ~= nil then
    return b
  end
  return vim.g.autoformat ~= false
end

-- Toggles format on save, globally or for the current buffer
function M.toggle(buffer)
  local on = not M.enabled(0)
  if buffer then
    vim.b.autoformat = on
  else
    vim.g.autoformat = on
    vim.b.autoformat = nil
  end
  vim.notify(("Autoformat %s%s"):format(on and "on" or "off", buffer and " (buffer)" or ""))
end

return M
