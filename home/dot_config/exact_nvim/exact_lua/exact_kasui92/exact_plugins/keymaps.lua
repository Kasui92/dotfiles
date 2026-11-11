local map = vim.keymap.set

require("which-key").add({
  { "<leader>a", group = "ai" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>d", group = "diff" },
  { "<leader>g", group = "git" },
  { "<leader>q", group = "session" },
  { "<leader>u", group = "toggle" },
  { "<leader>y", group = "yank" },
  { "<leader><tab>", group = "tabs" },
  { ";", group = "pick" },
  { "s", group = "split/oil" },
})

-- Oil
map("n", "sf", function()
  require("oil").open_float(nil, { preview = {} })
end, { desc = "Oil (file dir)" })
map("n", "sF", function()
  require("oil").open_float(Kasui92.root(), { preview = {} })
end, { desc = "Oil (project root)" })

-- Pickers
map("n", ";f", Snacks.picker.files, { desc = "Find files" })
map("n", ";r", Snacks.picker.grep, { desc = "Live grep" })
map({ "n", "x" }, ";w", Snacks.picker.grep_word, { desc = "Grep word or selection" })
map("n", ";;", Snacks.picker.resume, { desc = "Resume picker" })
map("n", ";e", Snacks.picker.diagnostics, { desc = "Diagnostics" })
map("n", ";s", Snacks.picker.lsp_symbols, { desc = "Symbols" })
map("n", ";S", Snacks.picker.lsp_workspace_symbols, { desc = "Workspace symbols" })
map("n", ";c", Snacks.picker.lsp_incoming_calls, { desc = "Incoming calls" })
map("n", ";n", Snacks.picker.notifications, { desc = "Notifications" })
map("n", ";k", Snacks.picker.keymaps, { desc = "Keymaps" })
map("n", ";h", Snacks.picker.git_diff, { desc = "Git diff (hunks)" })
map("n", ";t", function()
  Snacks.picker.todo_comments()
end, { desc = "Todo comments" })
map("n", ";R", function()
  require("grug-far").open()
end, { desc = "Search and replace" })
map("x", ";R", function()
  require("grug-far").with_visual_selection()
end, { desc = "Search and replace selection" })
map("n", ";b", function()
  require("grug-far").open({
    prefills = { search = vim.fn.expand("<cword>"), paths = vim.fn.expand("%"):gsub(" ", "\\ ") },
  })
end, { desc = "Search and replace in buffer" })
map("x", ";b", function()
  require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%"):gsub(" ", "\\ ") } })
end, { desc = "Search and replace selection in buffer" })
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Prev todo comment" })
map("n", ";g", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })

-- Buffers; jumps to the window already showing the buffer, in any tab
map("n", "\\\\", function()
  Snacks.picker.buffers({
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      vim.schedule(function()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            if vim.api.nvim_win_get_buf(win) == item.buf then
              vim.api.nvim_set_current_tabpage(tab)
              vim.api.nvim_set_current_win(win)
              return
            end
          end
        end
        vim.api.nvim_set_current_buf(item.buf)
      end)
    end,
  })
end, { desc = "Buffers" })

map("n", "]]", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev reference" })

-- LSP; the native gr* keys give way to gr
for _, lhs in ipairs({ "grn", "grr", "gri", "gra", "grt", "grx" }) do
  pcall(vim.keymap.del, { "n", "x" }, lhs)
end
map("n", "gd", Snacks.picker.lsp_definitions, { desc = "Goto definition" })
map("n", "<C-w>gd", function()
  Snacks.picker.lsp_definitions({ confirm = { action = "jump", cmd = "tab" } })
end, { desc = "Goto definition in new tab" })
map("n", "gD", Snacks.picker.lsp_declarations, { desc = "Goto declaration" })
map("n", "gy", Snacks.picker.lsp_type_definitions, { desc = "Goto type definition" })
map("n", "gr", Snacks.picker.lsp_references, { desc = "References" })
map("n", "gI", function()
  local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
  if not client then
    return vim.lsp.buf.implementation()
  end
  local params = vim.lsp.util.make_position_params(0, "utf-16")
  client:request("workspace/executeCommand", {
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  }, function(err, result)
    if err then
      return vim.notify("goToSourceDefinition: " .. err.message, vim.log.levels.ERROR)
    end
    if result and #result > 0 then
      vim.lsp.util.show_document(result[1], "utf-16", { focus = true })
    else
      vim.notify("No source definition found")
    end
  end, 0)
end, { desc = "Goto source definition / implementation" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>cR", Snacks.rename.rename_file, { desc = "Rename file" })
map("n", "<leader>cl", Snacks.picker.lsp_config, { desc = "LSP info" })
map("n", "<leader>co", function()
  vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
end, { desc = "Organize imports" })
map("n", "<leader>cM", function()
  vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" }, diagnostics = {} } })
end, { desc = "Add missing imports" })
map("n", "<leader>cD", function()
  vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ts" }, diagnostics = {} } })
end, { desc = "Fix all diagnostics" })
map({ "n", "x" }, "<leader>f", function()
  require("conform").format()
end, { desc = "Format" })

-- Git; ]h [h hunks and gh gH apply/reset come from mini.diff
map("n", "<leader>gd", function()
  MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
map({ "n", "x" }, "<leader>gl", function()
  Snacks.gitbrowse()
end, { desc = "Open in browser (GitHub/GitLab)" })
map("n", "<leader>gb", function()
  require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
  require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>gs", function()
  local gs = require("gitsigns")
  if #(gs.get_hunks() or {}) > 0 then
    gs.stage_buffer()
  else
    gs.reset_buffer_index()
  end
end, { desc = "Toggle stage buffer" })
map("n", "<leader>gh", function()
  require("gitsigns").stage_hunk()
end, { desc = "Toggle stage hunk" })
map("n", "<leader>dv", "<cmd>CodeDiff<cr>", { desc = "CodeDiff (changes)" })
map("n", "<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "CodeDiff (file history)" })
map("n", "<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "CodeDiff (repo history)" })

map("n", "<leader>j", Kasui92.editor.open_package_json, { desc = "package.json" })
map("n", "<leader>bd", Kasui92.editor.delete_hidden_buffers, { desc = "Delete hidden buffers" })

-- Sessions (persistence)
map("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore session (cwd)" })
map("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })
map("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Don't save session on exit" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Claude
local function claude(args)
  return function()
    Kasui92.zellij.claude(args)
  end
end
map("n", "<leader>ac", claude(), { desc = "Claude (zellij)" })
map("n", "<leader>af", "<cmd>ClaudeCode<cr>", { desc = "Claude (float)" })
map("n", "<leader>ar", claude({ "--resume" }), { desc = "Resume Claude" })
map("n", "<leader>aC", claude({ "--continue" }), { desc = "Continue Claude" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add buffer to Claude" })
map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("kasui92_oil_claude", { clear = true }),
  pattern = "oil",
  callback = function(ev)
    map("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = ev.buf, desc = "Add file to Claude" })
  end,
})

-- package.json dependencies
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("kasui92_package_info", { clear = true }),
  pattern = "package.json",
  callback = function(ev)
    local function bmap(lhs, cmd, desc)
      map("n", lhs, "<cmd>" .. cmd .. "<cr>", { buffer = ev.buf, desc = desc })
    end
    require("which-key").add({ { "<leader>n", group = "npm", buffer = ev.buf } })
    bmap("<leader>nt", "PackageInfoToggle", "Toggle versions")
    bmap("<leader>nr", "PackageInfoShowForce", "Refresh versions")
    bmap("<leader>nu", "PackageInfoUpdate", "Update dependency")
    bmap("<leader>nd", "PackageInfoDelete", "Delete dependency")
    bmap("<leader>ni", "PackageInfoInstall", "Install dependency")
    bmap("<leader>nc", "PackageInfoChangeVersion", "Change version")
  end,
})

-- Zellij
if vim.env.ZELLIJ then
  map("n", "<leader>z", function()
    Kasui92.zellij.float(Kasui92.root())
  end, { desc = "Zellij float (project root)" })
  map("n", "<leader>Z", function()
    Kasui92.zellij.float(vim.fn.getcwd())
  end, { desc = "Zellij float (cwd)" })
end

-- Alt hjkl navigate in insert mode too; visual keeps moving lines
map({ "n", "i" }, "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>", { desc = "Navigate left or tab" })
map({ "n", "i" }, "<A-j>", "<cmd>ZellijNavigateDown<cr>", { desc = "Navigate down" })
map({ "n", "i" }, "<A-k>", "<cmd>ZellijNavigateUp<cr>", { desc = "Navigate up" })
map({ "n", "i" }, "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { desc = "Navigate right or tab" })
