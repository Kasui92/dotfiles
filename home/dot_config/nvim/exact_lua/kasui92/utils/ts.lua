local M = {}

-- TypeScript major version installed for the buffer's project, 0 if none
function M.major(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  local pkg = vim.fs.find("node_modules/typescript/package.json", { upward = true, path = dir })[1]
  if not pkg then
    return 0
  end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
  return ok and tonumber(tostring(data.version):match("^(%d+)")) or 0
end

return M
