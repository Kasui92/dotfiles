local M = {}

local MAX_NAME = 20

-- Label for a tabpage: icon and name of the file in its active window, [+] when modified
local function label(tabnr)
  local buf = vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)]
  local path = vim.api.nvim_buf_get_name(buf)
  local name = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
  if vim.fn.strchars(name) > MAX_NAME then
    name = vim.fn.strcharpart(name, 0, MAX_NAME - 1) .. "…"
  end
  local icon = _G.MiniIcons and (MiniIcons.get("file", name)) or ""
  local modified = vim.bo[buf].modified and "[+] " or ""
  return (" %s%s %s "):format(modified, icon, name)
end

-- Tab with the rounded ends of the Kasui92 Tab Caps font, like the zjstatus tabs
function M.render()
  local parts = {}
  local current = vim.fn.tabpagenr()
  for tabnr = 1, vim.fn.tabpagenr("$") do
    local hl = tabnr == current and "TabLineSel" or "TabLine"
    parts[#parts + 1] = ("%%%dT%%#%sEdge#\u{100000}%%#%s#%s%%#%sEdge#\u{100001}"):format(tabnr, hl, hl, label(tabnr), hl)
  end
  return table.concat(parts, "%#TabLineFill# ") .. "%#TabLineFill#%T"
end

return M
