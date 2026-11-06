vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- UI
opt.number = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.laststatus = 3
opt.showmode = false
opt.cmdheight = 0
opt.winborder = "rounded"
opt.pumheight = 10
opt.fillchars = { foldopen = "\u{f078}", foldclose = "\u{f054}", fold = " ", foldsep = " ", diff = "╱", eob = " " }

-- Tabpages instead of a buffer line, shown only with 2+ tabs
opt.showtabline = 1
opt.tabline = "%!v:lua.Kasui92.tabline.render()"

-- Editing
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.virtualedit = "block"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.wildmode = "longest:full,full"

-- Files
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.updatetime = 200
opt.timeoutlen = 500

-- Windows
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.jumpoptions = "view"

-- Treesitter folds, all open
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99

-- sample.env and similar as shell, like .env
vim.filetype.add({ pattern = { [".*%.env"] = "sh" } })
