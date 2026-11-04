return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      styles = { transparency = true },
      -- Tabline colors matching the zjstatus tabs
      highlight_groups = {
        TabLine = { fg = "text", bg = "overlay" },
        TabLineEdge = { fg = "overlay", bg = "NONE" },
        TabLineSel = { fg = "base", bg = "iris", bold = true },
        TabLineSelEdge = { fg = "iris", bg = "NONE" },
        TabLineFill = { bg = "NONE" },
      },
    },
  },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
      news = { lazyvim = false, neovim = false },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      styles = {
        -- border = true follows vim.o.winborder
        lazygit = { border = true },
        terminal = { border = true },
      },
    },
  },
}
