return {
  {
    "swaits/zellij-nav.nvim",
    event = "VeryLazy",
    keys = {
      { "<a-h>", "<cmd>ZellijNavigateLeftTab<cr>", silent = true, desc = "Navigate left or tab" },
      { "<a-j>", "<cmd>ZellijNavigateDown<cr>", silent = true, desc = "Navigate down" },
      { "<a-k>", "<cmd>ZellijNavigateUp<cr>", silent = true, desc = "Navigate up" },
      { "<a-l>", "<cmd>ZellijNavigateRightTab<cr>", silent = true, desc = "Navigate right or tab" },
    },
    opts = {},
  },

  -- No file tree: oil and the picker instead
  {
    "folke/snacks.nvim",
    opts = { explorer = { enabled = false } },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },

  -- Edit the filesystem as a buffer
  {
    "stevearc/oil.nvim",
    -- Loaded at startup so `nvim <dir>` opens oil
    lazy = false,
    keys = {
      {
        "-",
        function()
          require("oil").open_float(nil, { preview = {} })
        end,
        desc = "Oil (parent dir)",
      },
      {
        "<leader>e",
        function()
          require("oil").open_float(LazyVim.root(), { preview = {} })
        end,
        desc = "Oil (root dir)",
      },
      {
        "<leader>E",
        function()
          require("oil").open_float(vim.fn.getcwd(), { preview = {} })
        end,
        desc = "Oil (cwd)",
      },
    },
    opts = {
      columns = { "icon" },
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
      view_options = { show_hidden = true },
      float = { max_width = 160 },
      preview_win = { update_on_cursor_moved = true },
      -- Renames and moves update imports through the LSP
      lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
    },
  },

  -- Side-by-side git diff with a file explorer and history
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gv", "<cmd>CodeDiff<cr>", desc = "CodeDiff (changes)" },
      { "<leader>gV", "<cmd>CodeDiff history %<cr>", desc = "CodeDiff (file history)" },
    },
    opts = {},
  },
}
