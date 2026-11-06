---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      diagnostics = { globals = { "Kasui92", "Snacks", "MiniIcons", "MiniDiff" } },
      hint = { enable = true, setType = false, paramType = true, paramName = "Disable", arrayIndex = "Disable" },
      completion = { callSnippet = "Replace" },
    },
  },
}
