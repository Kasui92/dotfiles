local function augroup(name)
  return vim.api.nvim_create_augroup("kasui92_" .. name, { clear = true })
end

-- Reload files changed on disk, e.g. by claude in another pane
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Cd into the directory given as the only argument
local arg_dir = vim.fn.argc() == 1 and vim.fn.fnamemodify(vim.fn.argv(0), ":p")
if arg_dir and vim.fn.isdirectory(arg_dir) == 1 then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("cd_arg_dir"),
    once = true,
    callback = function()
      vim.cmd.cd(arg_dir)
    end,
  })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Cursor back to the last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "gitcommit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
