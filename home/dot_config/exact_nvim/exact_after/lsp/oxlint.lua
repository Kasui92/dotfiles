-- Root at the oxlint config, top-level one first, oxlint.config.mts included
---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "oxlint.config.mts" }
    local git = vim.fs.root(bufnr, ".git")
    local root = git and vim.fs.root(git, markers) or vim.fs.root(bufnr, markers)
    if root then
      on_dir(root)
    end
  end,
  settings = { fixKind = "all" },
}
