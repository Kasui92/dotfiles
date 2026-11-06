require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Language servers
    "astro-language-server",
    "bash-language-server",
    "css-lsp",
    "dockerfile-language-server",
    "emmet-language-server",
    "eslint-lsp",
    "html-lsp",
    "intelephense",
    "json-lsp",
    "lua-language-server",
    "marksman",
    "oxlint",
    "tailwindcss-language-server",
    "vtsls",
    "yaml-language-server",
    -- Formatters and linters
    "hadolint",
    "markdown-toc",
    "oxfmt",
    "prettier",
    "shellcheck",
    "shfmt",
    "stylua",
    -- Compiles the treesitter parsers
    "tree-sitter-cli",
  },
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities({
    workspace = { fileOperations = { didRename = true, willRename = true } },
  }),
})

-- Native tsc LSP in TypeScript 7 projects, vtsls in older ones.
-- tsc's cmd and root_dir share the binary cache of one load of its config file.
local vtsls = vim.lsp.config.vtsls
local tsc = vim.lsp.config.tsc
vim.lsp.config("vtsls", {
  root_dir = function(bufnr, on_dir)
    if Kasui92.ts.major(bufnr) < 7 then
      vtsls.root_dir(bufnr, on_dir)
    end
  end,
})
vim.lsp.config("tsc", {
  cmd = tsc.cmd,
  root_dir = function(bufnr, on_dir)
    if Kasui92.ts.major(bufnr) >= 7 then
      tsc.root_dir(bufnr, on_dir)
    end
  end,
})

vim.lsp.config("tailwindcss", {
  filetypes = vim.tbl_filter(function(ft)
    return ft ~= "markdown" and ft ~= "php"
  end, vim.lsp.config.tailwindcss.filetypes),
})

-- Each diagnostic shows the tool and rule that raised it
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057} ",
      [vim.diagnostic.severity.WARN] = "\u{f071} ",
      [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
      [vim.diagnostic.severity.INFO] = "\u{f05a} ",
    },
  },
  virtual_text = {
    spacing = 4,
    prefix = "●",
    format = function(d)
      if d.source and d.code then
        return ("%s (%s: %s)"):format(d.message, d.source, d.code)
      elseif d.source then
        return ("%s (%s)"):format(d.message, d.source)
      end
      return d.message
    end,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kasui92_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

vim.lsp.enable({
  "vtsls",
  "tsc",
  "eslint",
  "oxlint",
  "tailwindcss",
  "cssls",
  "html",
  "emmet_language_server",
  "intelephense",
  "astro",
  "jsonls",
  "yamlls",
  "dockerls",
  "bashls",
  "lua_ls",
  "marksman",
})
