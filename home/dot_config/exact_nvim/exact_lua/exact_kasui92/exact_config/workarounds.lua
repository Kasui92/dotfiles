-- Workarounds for upstream bugs; remove each once fixed upstream

-- neovim/neovim#40290: the treesitter fold refresh on OptionSet (foldminlines, set by codediff)
-- runs on wiped buffers and fails with "Invalid buffer id"
require("vim.treesitter._fold")
for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet" })) do
  if au.desc == "Refresh treesitter folds" then
    vim.api.nvim_del_autocmd(au.id)
  end
end
