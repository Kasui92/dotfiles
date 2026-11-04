return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      styles = { transparency = true },
    },
  },
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },

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
