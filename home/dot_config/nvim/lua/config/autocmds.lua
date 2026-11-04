-- Strip trailing whitespace on save, except in markdown and diff
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if not vim.bo[ev.buf].modifiable or ft == "diff" or ft:match("^markdown") then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
