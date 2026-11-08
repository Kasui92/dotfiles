local M = {}

local function yank(text)
  vim.fn.setreg("+", text)
  vim.notify("Yanked: " .. text, vim.log.levels.INFO)
end

function M.yank_relative_path()
  yank(vim.fn.expand("%:.") .. "#L" .. vim.fn.line("."))
end

function M.yank_absolute_path()
  yank(vim.fn.expand("%:p") .. "#L" .. vim.fn.line("."))
end

-- Selection as a fenced code block with file name and first line
function M.yank_code_block()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local file = vim.api.nvim_buf_get_name(0)
  local root = Kasui92.root()
  local rel = file:sub(1, #root + 1) == root .. "/" and file:sub(#root + 2) or vim.fn.fnamemodify(file, ":.")
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  table.insert(lines, 1, ("```%s filename=%q line=%d"):format(vim.bo.filetype, rel, first))
  table.insert(lines, "```")
  vim.fn.setreg("+", table.concat(lines, "\n"))
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  vim.notify(("Yanked %d lines as code block"):format(last - first + 1), vim.log.levels.INFO)
end

-- package.json of the project root in a float, q closes it
function M.open_package_json()
  local path = Kasui92.root() .. "/package.json"
  if vim.fn.filereadable(path) == 0 then
    return vim.notify("No package.json in " .. Kasui92.root(), vim.log.levels.WARN)
  end
  Snacks.win({
    file = path,
    width = 0.8,
    height = 0.8,
    title = " package.json ",
    title_pos = "center",
    border = true,
    wo = { cursorline = true, number = true },
    keys = { q = "close" },
  })
end

return M
