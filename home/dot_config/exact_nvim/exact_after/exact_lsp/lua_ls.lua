---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        -- Runtime and vim.pack plugins
        library = vim.list_extend(
          { vim.env.VIMRUNTIME },
          vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/core/opt/*/lua", false, true)
        ),
      },
      diagnostics = { globals = { "Kasui92", "Snacks", "MiniIcons", "MiniDiff" } },
      hint = { enable = true, setType = false, paramType = true, paramName = "Disable", arrayIndex = "Disable" },
      completion = { callSnippet = "Replace" },
    },
  },
}
