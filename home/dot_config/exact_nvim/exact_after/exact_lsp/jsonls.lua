---@type vim.lsp.Config
return {
  settings = {
    json = { validate = { enable = true } },
  },
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
}
