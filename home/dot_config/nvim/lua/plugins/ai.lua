local function claude(args)
  return function()
    if not vim.env.ZELLIJ then
      return vim.notify("Claude opens in a zellij floating pane: not inside zellij", vim.log.levels.WARN)
    end
    require("config.zellij").claude(args)
  end
end

return {
  {
    "coder/claudecode.nvim",
    -- Claude runs in a zellij floating pane (Alt f hides it), connected through the env set by config.zellij
    event = "VeryLazy",
    opts = { terminal = { provider = "none" } },
    keys = {
      { "<leader>ac", claude(), desc = "Claude (zellij float)" },
      { "<leader>ar", claude({ "--resume" }), desc = "Resume Claude" },
      { "<leader>aC", claude({ "--continue" }), desc = "Continue Claude" },
      { "<leader>af", false },
    },
  },
}
