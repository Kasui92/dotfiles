local map = vim.keymap.set

-- Keep the yank register
map("n", "x", '"_x', { desc = "Delete char (no yank)" })

map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment line below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment line above" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.api.nvim_create_user_command("W", Kasui92.format.write_unformatted, { desc = "Save without formatting" })
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("nohlsearch")
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

-- Alt j/k move the selection; in normal and insert mode they navigate zellij panes
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selection up" })

map("n", "ss", "<cmd>split<cr>", { desc = "Split below" })
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Split right" })

-- Tabpage keys with the same letters as the zellij Alt tab keys; {n}gt goes to tab n
map("n", "<leader><tab>t", "<cmd>tabnew<cr>", { desc = "󰝜 New tab" })
map("n", "<leader><tab>x", "<cmd>tabclose<cr>", { desc = "󰭌 Close tab" })

map("n", "<leader>yf", Kasui92.editor.yank_relative_path, { desc = "󰈔 Relative path:line" })
map("n", "<leader>yp", Kasui92.editor.yank_absolute_path, { desc = "󰉋 Absolute path:line" })
map("x", "<leader>yc", Kasui92.editor.yank_code_block, { desc = "󰅴 As code block" })

map("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

map("n", "<leader>uf", function()
  Kasui92.format.toggle()
end, { desc = "󰉼 Autoformat" })
map("n", "<leader>uF", function()
  Kasui92.format.toggle(true)
end, { desc = "󰉼 Autoformat (buffer)" })
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "󰔨 Inlay hints" })
map("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "󰓆 Spelling" })
