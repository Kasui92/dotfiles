local M = {}

local function action(args)
  return vim.system(vim.list_extend({ "zellij", "action" }, args), { text = true })
end

-- Floating pane in dir, running cmd (default shell when nil)
function M.float(dir, cmd, extra)
  local args = vim.list_extend({ "new-pane", "--floating", "--cwd", dir }, extra or {})
  if cmd then
    vim.list_extend(args, { "--" })
    vim.list_extend(args, cmd)
  end
  action(args)
end

-- Id of the floating claude pane in this nvim's tab
local function claude_pane()
  local ok, panes = pcall(vim.json.decode, action({ "list-panes", "--json", "--all" }):wait().stdout or "")
  if not ok then
    return
  end
  local own, tab = tonumber(vim.env.ZELLIJ_PANE_ID), nil
  for _, p in ipairs(panes) do
    if not p.is_plugin and p.id == own then
      tab = p.tab_id
    end
  end
  for _, p in ipairs(panes) do
    if not p.is_plugin and p.is_floating and p.tab_id == tab and (p.terminal_command or ""):find("claude") then
      return p.id
    end
  end
end

-- Shows the tab's claude float, or starts one in the project root connected to this nvim
function M.claude(args)
  local id = claude_pane()
  if id then
    action({ "show-floating-panes" }):wait()
    action({ "focus-pane-id", "terminal_" .. id })
    return
  end
  local cmd = { "env", "ENABLE_IDE_INTEGRATION=true", "FORCE_CODE_TERMINAL=true" }
  local port = require("claudecode").state.port
  if port then
    cmd[#cmd + 1] = "CLAUDE_CODE_SSE_PORT=" .. port
  end
  cmd[#cmd + 1] = "claude"
  vim.list_extend(cmd, args or {})
  M.float(LazyVim.root(), cmd, {
    "--name",
    "claude",
    "--close-on-exit",
    "--width",
    "80%",
    "--height",
    "80%",
    "--x",
    "10%",
    "--y",
    "10%",
  })
end

return M
