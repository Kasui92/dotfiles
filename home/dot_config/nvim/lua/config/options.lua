vim.opt.relativenumber = false
vim.o.winborder = "rounded"

-- Tabpages instead of a buffer line, shown only with 2+ tabs
vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.require('config.tabline').render()"

vim.g.lazyvim_php_lsp = "intelephense"
-- Prettier only formats projects that have a prettier config
vim.g.lazyvim_prettier_needs_config = true
