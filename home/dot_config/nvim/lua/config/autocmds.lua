-- Strip trailing whitespace on save, except in markdown and diff
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if not vim.bo[ev.buf].modifiable or ft == "diff" or ft:match("^markdown") then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Formatting comes from conform (prettier/oxfmt only with a project config) and eslint, never from these servers
local no_lsp_format =
  { vtsls = true, tsc = true, cssls = true, html = true, jsonls = true, yamlls = true, astro = true }
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("no_lsp_format", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and no_lsp_format[client.name] then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})
