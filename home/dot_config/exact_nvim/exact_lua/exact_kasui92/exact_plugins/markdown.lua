-- Rendered headings, code blocks, lists and alerts; the cursor line shows the source.
-- Callout and checkbox completions come from an in-process LSP that blink picks up.
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  heading = { sign = false },
  code = { sign = false },
})

-- jaamd directive lines (:::code-tabs, :::toc[...], closing :::) outside code blocks
vim.api.nvim_set_hl(0, "MarkdownDirective", { link = "Special", default = true })

local ns = vim.api.nvim_create_namespace("kasui92_markdown_directives")
local enabled = {}
local code_nodes = { fenced_code_block = true, indented_code_block = true }

local function in_code(buf, row, col)
  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, col }, ignore_injections = true })
  while node do
    if code_nodes[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

-- Highlights only the visible lines, after parsing only that range
vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, buf, top, bot)
    if not enabled[buf] then
      return false
    end
    local parser = vim.treesitter.get_parser(buf, "markdown", { error = false })
    if not parser then
      return false
    end
    parser:parse({ top, bot + 1 })
    for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, top, bot + 1, false)) do
      local indent = line:match("^(%s*):::")
      local row = top + i - 1
      if indent and not in_code(buf, row, #indent) then
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          end_col = #line,
          hl_group = "MarkdownDirective",
          priority = vim.hl.priorities.treesitter + 1,
          ephemeral = true,
        })
      end
    end
    return false
  end,
})

local function directives(buf)
  if enabled[buf] then
    return
  end
  enabled[buf] = true
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      enabled[buf] = nil
    end,
  })
end

-- LSP hover and signature floats are markdown too: they get wrap but no directives or keys
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("kasui92_markdown", { clear = true }),
  pattern = "markdown",
  callback = function(ev)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end
    directives(ev.buf)
    vim.keymap.set(
      "n",
      "<leader>um",
      "<cmd>RenderMarkdown buf_toggle<cr>",
      { buffer = ev.buf, desc = "Toggle markdown render" }
    )
  end,
})
