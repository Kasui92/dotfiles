local map = vim.keymap.set

-- Keep the yank register
map("n", "x", '"_x', { desc = "Delete char (no yank)" })
map({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste last yank" })

local function yank(text)
  vim.fn.setreg("+", text)
  vim.notify("Yanked: " .. text, vim.log.levels.INFO)
end

map("n", "<leader>yf", function()
  yank(vim.fn.expand("%:.") .. "#L" .. vim.fn.line("."))
end, { desc = "Yank relative path:line" })

map("n", "<leader>yp", function()
  yank(vim.fn.expand("%:p") .. "#L" .. vim.fn.line("."))
end, { desc = "Yank absolute path:line" })

-- Selection as a fenced code block with file name and first line
map("x", "<leader>yc", function()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local file = vim.api.nvim_buf_get_name(0)
  local root = LazyVim.root()
  local rel = file:sub(1, #root + 1) == root .. "/" and file:sub(#root + 2) or vim.fn.fnamemodify(file, ":.")
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  table.insert(lines, 1, ("```%s filename=%q line=%d"):format(vim.bo.filetype, rel, first))
  table.insert(lines, "```")
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.notify(("Yanked %d lines as code block"):format(last - first + 1), vim.log.levels.INFO)
end, { desc = "Yank as code block" })

-- Floating zellij pane in the project root or cwd
if vim.env.ZELLIJ then
  local zellij = require("config.zellij")
  map("n", "<leader>fz", function()
    zellij.float(LazyVim.root())
  end, { desc = "Zellij float (Root Dir)" })
  map("n", "<leader>fZ", function()
    zellij.float(vim.fn.getcwd())
  end, { desc = "Zellij float (cwd)" })
end
