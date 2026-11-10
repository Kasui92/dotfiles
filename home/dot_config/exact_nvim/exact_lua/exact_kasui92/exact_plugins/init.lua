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
  gh("b0o/incline.nvim"),
  gh("brenoprata10/nvim-highlight-colors"),
  -- Editor
  { src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
  gh("rafamadriz/friendly-snippets"),
  gh("nvim-mini/mini.pairs"),
  gh("windwp/nvim-ts-autotag"),
  gh("axelvc/template-string.nvim"),
  gh("folke/ts-comments.nvim"),
  gh("folke/todo-comments.nvim"),
  gh("MagicDuck/grug-far.nvim"),
  gh("kylechui/nvim-surround"),
  gh("nvim-mini/mini.ai"),
  gh("nvim-mini/mini.diff"),
  gh("folke/persistence.nvim"),
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
  gh("MunifTanjim/nui.nvim"),
  gh("vuki656/package-info.nvim"),
})

-- Each module loads on its own: an error is notified and the others still load
local function load(name)
  local ok, err = pcall(require, "kasui92.plugins." .. name)
  if not ok then
    vim.notify(("kasui92.plugins.%s: %s"):format(name, err), vim.log.levels.ERROR)
  end
end

-- Machine-local plugins, not managed by chezmoi
if #vim.api.nvim_get_runtime_file("lua/kasui92/plugins/local.lua", false) > 0 then
  load("local")
end

for _, name in ipairs({ "ui", "editor", "lsp", "treesitter", "util", "keymaps" }) do
  load(name)
end
