-- Edit the filesystem as a buffer; also opens on `nvim <dir>`
require("oil").setup({
  columns = { "icon" },
  keymaps = {
    ["h"] = { "actions.parent", mode = "n" },
    ["l"] = { "actions.select", mode = "n" },
    -- No-op when oil is the only buffer
    ["q"] = {
      callback = function()
        local orig = vim.w.oil_original_buffer
        if
          vim.w.is_oil_win
          or (orig and vim.api.nvim_buf_is_valid(orig))
          or #vim.fn.getbufinfo({ buflisted = 1 }) > 1
        then
          require("oil").close()
        end
      end,
      mode = "n",
      desc = "Close oil",
    },
  },
  view_options = {
    show_hidden = true,
    -- No parent entry: h or - go up
    is_always_hidden = function(name)
      return name == ".."
    end,
  },
  float = { max_width = 160 },
  preview_win = { update_on_cursor_moved = true },
  -- Renames and moves update imports through the LSP
  lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
})

-- Closes the preview of a closed oil float
vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("kasui92_oil_preview", { clear = true }),
  callback = function(args)
    local closed = tonumber(args.match)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.w[win].oil_preview and vim.w[win].oil_source_win == closed then
        vim.schedule(function()
          pcall(vim.api.nvim_win_close, win, true)
        end)
      end
    end
  end,
})

-- Alt hjkl across nvim splits and zellij panes
require("zellij-nav").setup({})

-- Claude runs in a zellij floating pane (Alt f hides it), connected through the env set by Kasui92.zellij,
-- or in a snacks float in the project root via :ClaudeCode
require("claudecode").setup({
  log_level = "warn",
  terminal = {
    provider = "snacks",
    cwd_provider = function()
      return Kasui92.root()
    end,
    -- Double Esc goes to claude; Ctrl q hides the float
    snacks_win_opts = {
      position = "float",
      width = 0.8,
      height = 0.8,
      border = true,
      keys = {
        term_normal = false,
        claude_hide = { "<C-q>", "hide", mode = "t" },
      },
    },
  },
})

-- Latest dependency versions as virtual text in package.json
require("package-info").setup()
