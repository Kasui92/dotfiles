-- PHP 8.4 like the containers, no formatting
---@type vim.lsp.Config
return {
  settings = {
    intelephense = {
      environment = { phpVersion = "8.4.0" },
      format = { enable = false },
    },
  },
}
