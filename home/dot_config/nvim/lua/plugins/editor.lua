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

  -- Function signature while typing the arguments
  {
    "saghen/blink.cmp",
    opts = { signature = { enabled = true } },
  },

  -- Quotes become backticks when typing ${
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    opts = {
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    },
  },

  -- No file tree: oil and the picker instead
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      -- Toggles moved off the keys zellij binds (Alt h/f/p/r, Ctrl g)
      picker = {
        win = {
          input = {
            keys = {
              ["<a-.>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<a-s>"] = { "toggle_follow", mode = { "i", "n" } },
              ["<a-v>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<a-e>"] = { "toggle_regex", mode = { "i", "n" } },
              ["<c-l>"] = { "toggle_live", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<a-.>"] = "toggle_hidden",
              ["<a-s>"] = "toggle_follow",
              ["<a-v>"] = "toggle_preview",
            },
          },
        },
      },
    },
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
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".."
        end,
      },
      float = { max_width = 160 },
      preview_win = { update_on_cursor_moved = true },
      -- Renames and moves update imports through the LSP
      lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      -- Closes the preview of a closed oil float
      vim.api.nvim_create_autocmd("WinClosed", {
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
    end,
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
