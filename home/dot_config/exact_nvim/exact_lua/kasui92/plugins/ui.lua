require("rose-pine").setup({
  styles = { transparency = true },
  -- Tabline colors matching the zjstatus tabs
  highlight_groups = {
    TabLine = { fg = "text", bg = "overlay" },
    TabLineEdge = { fg = "overlay", bg = "NONE" },
    TabLineSel = { fg = "base", bg = "iris", bold = true },
    TabLineSelEdge = { fg = "iris", bg = "NONE" },
    TabLineFill = { bg = "NONE" },
  },
})
vim.cmd.colorscheme("rose-pine")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Cmdline and messages in floating windows, with cmdheight = 0
require("vim._core.ui2").enable({
  msg = {
    target = "msg",
    targets = { list_cmd = "pager", verbose = "pager", shell_out = "pager", shell_err = "pager" },
  },
})

require("snacks").setup({
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
    },
    -- Toggles moved off the keys zellij binds (Alt h/f/p/r, Ctrl g)
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
  styles = {
    lazygit = { border = true },
    terminal = { border = true },
  },
  gitbrowse = {
    url_patterns = {
      -- Self-hosted GitLab instances
      ["gitlab%."] = {
        branch = "/-/tree/{branch}",
        file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
        permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
        commit = "/-/commit/{commit}",
      },
      ["codeberg%.org"] = {
        branch = "/src/branch/{branch}",
        file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}",
        permalink = "/src/commit/{commit}/{file}#L{line_start}-L{line_end}",
        commit = "/commit/{commit}",
      },
    },
  },
})

-- Popup with the next keys after a prefix
require("which-key").setup({ preset = "helix" })

-- File name at the top right of each window
require("incline").setup({
  window = { margin = { vertical = 0, horizontal = 1 }, zindex = 10 },
  hide = { cursorline = "smart" },
  render = function(props)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if name == "" then
      name = "[No Name]"
    end
    if vim.bo[props.buf].modified then
      name = "[+] " .. name
    end
    local icon, hl = MiniIcons.get("file", name)
    return { { icon, group = hl }, { " " }, { name } }
  end,
})

-- Colors behind #hex, rgb(), hsl(), CSS variables and Tailwind classes, in any file
vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
  render = "background",
  enable_hex = true,
  enable_short_hex = true,
  enable_rgb = true,
  enable_hsl = true,
  enable_var_usage = true,
  enable_tailwind = true,
})

require("lualine").setup({
  options = {
    theme = "rose-pine",
    globalstatus = true,
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "diagnostics", { "filename", path = 1 } },
    lualine_x = { "diff", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
