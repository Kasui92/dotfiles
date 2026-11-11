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
  return action(args)
end

-- Pane id ("terminal_<n>") of the claude float started by this nvim
local claude_id

-- Tab id of claude_id while the pane is still open
local function claude_tab()
  if not claude_id then
    return
  end
  local ok, panes = pcall(
    vim.json.decode,
    action({ "list-panes", "--json", "--all" }):wait().stdout or "",
    { luanil = { object = true, array = true } }
  )
  if not ok then
    return
  end
  for _, p in ipairs(panes) do
    if not p.is_plugin and "terminal_" .. p.id == claude_id and not p.exited then
      return p.tab_id
    end
  end
end

-- Shows this nvim's claude float, or starts one in the project root connected to this nvim
function M.claude(args)
  if not vim.env.ZELLIJ then
    return vim.notify("Claude opens in a zellij floating pane: not inside zellij", vim.log.levels.WARN)
  end
  local tab = claude_tab()
  if tab then
    action({ "show-floating-panes", "--tab-id", tostring(tab) }):wait()
    action({ "focus-pane-id", claude_id })
    return
  end
  local cmd = { "env", "ENABLE_IDE_INTEGRATION=true", "FORCE_CODE_TERMINAL=true" }
  local port = require("claudecode").state.port
  if port then
    cmd[#cmd + 1] = "CLAUDE_CODE_SSE_PORT=" .. port
  end
  cmd[#cmd + 1] = "claude"
  vim.list_extend(cmd, args or {})
  local out = M.float(Kasui92.root(), cmd, {
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
  }):wait().stdout or ""
  claude_id = out:match("terminal_%d+")
end

return M
