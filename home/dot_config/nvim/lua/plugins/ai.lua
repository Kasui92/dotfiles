return {
  {
    "coder/claudecode.nvim",
    -- Claude runs in its own zellij pane and connects with /ide
    event = "VeryLazy",
    opts = { terminal = { provider = "none" } },
  },
}
