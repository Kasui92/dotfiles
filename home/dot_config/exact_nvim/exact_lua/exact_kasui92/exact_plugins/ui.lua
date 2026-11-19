require("rose-pine").setup({
  styles = { transparency = true },
  highlight_groups = {
    -- lualine tabs: the current one stands out like the active zjstatus tab
    LualineTabActive = { fg = "iris", bold = true },
    LualineTabInactive = { fg = "muted" },
    -- package-info.nvim virtual text
    PackageInfoUpToDateVersion = { fg = "muted" },
    PackageInfoOutdatedVersion = { fg = "gold" },
    PackageInfoInErrorVersion = { fg = "love" },
  },
})
vim.cmd.colorscheme("rose-pine")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Cmdline and messages in floating windows, with cmdheight = 0; ui2 is an experimental core module
local ok, err = pcall(function()
  require("vim._core.ui2").enable({
    msg = {
      target = "msg",
      targets = { list_cmd = "pager", verbose = "pager", shell_out = "pager", shell_err = "pager" },
    },
  })
end)
if not ok then
  vim.notify("ui2: " .. err, vim.log.levels.WARN)
end

require("snacks").setup({
  -- Big files without treesitter, LSP and other heavy features
  bigfile = { enabled = true },
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
  -- Files edited from lazygit open in the window it was launched from
  lazygit = {
    config = {
      os = { edit = Kasui92.lazygit.edit_command(), editAtLine = Kasui92.lazygit.edit_command(true) },
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

-- Menus for <Leader> and ; (pickers): they wait for the next key, the window shows after delay.
-- ; alone (repeat f/t) runs with ; <CR>
-- Actions take their icon from the mapping desc, which wins over clue desc; groups get it here.
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = ";" },
    { mode = "x", keys = ";" },
    { mode = "n", keys = "[" },
    { mode = "x", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "]" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "'" },
    { mode = "x", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "`" },
  },
  clues = {
    { mode = { "n", "x" }, keys = "<Leader>a", desc = "󰚩 Claude" },
    { mode = "n", keys = "<Leader>b", desc = "󰈔 Buffers" },
    { mode = { "n", "x" }, keys = "<Leader>c", desc = "󰅩 Code" },
    { mode = "n", keys = "<Leader>d", desc = "󰢪 CodeDiff" },
    { mode = { "n", "x" }, keys = "<Leader>g", desc = "󰊢 Git" },
    { mode = "n", keys = "<Leader>q", desc = "󰆓 Session" },
    { mode = "n", keys = "<Leader>u", desc = "󰔡 Toggles" },
    { mode = { "n", "x" }, keys = "<Leader>y", desc = "󰆏 Yank" },
    { mode = "n", keys = "<Leader><Tab>", desc = "󰓩 Tabs" },
    miniclue.gen_clues.z(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.marks(),
  },
  window = { delay = 300, config = { width = "auto" } },
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

-- Status line on the terminal background: the mode keeps its color as bold text, no blocks.
-- A function, so lualine rebuilds it with the current rose-pine variant on ColorScheme.
local function text_theme()
  local p = require("rose-pine.palette")

  local function sections(mode_color)
    return {
      a = { fg = mode_color, bg = "NONE", gui = "bold" },
      b = { fg = p.subtle, bg = "NONE" },
      c = { fg = p.text, bg = "NONE" },
    }
  end

  return {
    normal = sections(p.rose),
    insert = sections(p.foam),
    visual = sections(p.iris),
    replace = sections(p.pine),
    command = sections(p.love),
    inactive = sections(p.muted),
  }
end

require("lualine").setup({
  options = {
    theme = text_theme,
    globalstatus = true,
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    -- Tabpages in place of the file name: the current tab shows the file being edited
    lualine_c = {
      {
        "tabs",
        mode = 2, -- index and name, like the zjstatus tabs
        max_length = function()
          return math.floor(vim.o.columns / 2)
        end,
        tabs_color = { active = "LualineTabActive", inactive = "LualineTabInactive" },
        fmt = function(name)
          local icon = MiniIcons.get("file", name)
          return icon .. " " .. name
        end,
      },
      "diagnostics",
    },
    lualine_x = {
      {
        "diff",
        -- Counts of the mini.diff signs
        source = function()
          local s = vim.b.minidiff_summary
          return s and { added = s.add, modified = s.change, removed = s.delete }
        end,
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
