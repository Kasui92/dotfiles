---@type vim.lsp.Config
return {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      validate = true,
      -- Schemas from SchemaStore.nvim instead of the built-in download
      schemaStore = { enable = false, url = "" },
    },
  },
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
}
