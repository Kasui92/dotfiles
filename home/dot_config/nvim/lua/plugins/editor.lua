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
}
