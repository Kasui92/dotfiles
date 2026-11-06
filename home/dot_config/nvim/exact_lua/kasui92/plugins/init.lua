local function gh(repo)
  return "https://github.com/" .. repo
end

-- Parsers recompiled after nvim-treesitter updates
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("kasui92_pack", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- chezmoi.vim reads these when loaded
vim.g["chezmoi#use_tmp_buffer"] = 1
vim.g["chezmoi#source_dir_path"] = vim.env.HOME .. "/.local/share/chezmoi/home"

vim.pack.add({
  -- UI
  { src = gh("rose-pine/neovim"), name = "rose-pine" },
  gh("nvim-mini/mini.icons"),
  gh("folke/snacks.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/which-key.nvim"),
  gh("esmuellert/codediff.nvim"),
  -- Editor
  { src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
  gh("rafamadriz/friendly-snippets"),
  gh("nvim-mini/mini.pairs"),
  gh("windwp/nvim-ts-autotag"),
  gh("axelvc/template-string.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("stevearc/conform.nvim"),
  gh("mfussenegger/nvim-lint"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  -- LSP
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("b0o/SchemaStore.nvim"),
  -- Util
  gh("stevearc/oil.nvim"),
  gh("swaits/zellij-nav.nvim"),
  gh("coder/claudecode.nvim"),
  gh("alker0/chezmoi.vim"),
})

require("kasui92.plugins.ui")
require("kasui92.plugins.editor")
require("kasui92.plugins.lsp")
require("kasui92.plugins.treesitter")
require("kasui92.plugins.util")
require("kasui92.plugins.keymaps")
require("kasui92.plugins.whichkey")
