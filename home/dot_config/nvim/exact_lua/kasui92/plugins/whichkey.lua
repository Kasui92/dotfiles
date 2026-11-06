-- Popup with the next keys after a prefix
local wk = require("which-key")
wk.setup({ preset = "helix" })
wk.add({
  { "<leader>a", group = "ai" },
  { "<leader>c", group = "code" },
  { "<leader>d", group = "diff" },
  { "<leader>g", group = "git" },
  { "<leader>u", group = "toggle" },
  { "<leader>y", group = "yank" },
  { "<leader><tab>", group = "tabs" },
  { ";", group = "pick" },
  { "s", group = "split/oil" },
})
