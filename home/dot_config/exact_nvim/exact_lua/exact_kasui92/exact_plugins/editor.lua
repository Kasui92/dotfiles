require("blink.cmp").setup({
  keymap = { preset = "enter", ["<C-y>"] = { "select_and_accept" } },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    -- No first item preselected in markdown, so Enter after a prose word inserts a newline
    list = {
      selection = {
        preselect = function()
          return vim.bo.filetype ~= "markdown"
        end,
      },
    },
    menu = { draw = { treesitter = { "lsp" } } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  -- Function signature while typing the arguments
  signature = { enabled = true },
  cmdline = {
    keymap = { preset = "cmdline", ["<Right>"] = false, ["<Left>"] = false },
    completion = {
      list = { selection = { preselect = false } },
      menu = {
        auto_show = function()
          return vim.fn.getcmdtype() == ":"
        end,
      },
    },
  },
})

require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = false } })
require("nvim-ts-autotag").setup()

-- Quotes become backticks when typing ${
require("template-string").setup({
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
})

-- gc with the comment syntax of the language at the cursor (JSX, Astro, Vue)
require("ts-comments").setup()

-- TODO, FIXME, HACK, NOTE... highlighted and searchable
require("todo-comments").setup()

-- Project-wide search and replace with preview
require("grug-far").setup({ headerMaxWidth = 80 })

-- ys/cs/ds add, change or delete quotes, brackets and tags around text
require("nvim-surround").setup()

-- a/i text objects: f function, c class, o block/conditional/loop, u call, plus the
-- mini.ai defaults (a argument, t tag, quotes and brackets)
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    u = ai.gen_spec.function_call(),
  },
})

-- Session per cwd, saved on exit
require("persistence").setup()

-- Change signs, hunk navigation (]c [c, like codediff) and overlay; gitsigns keeps blame and stage
require("mini.diff").setup({ mappings = { goto_next = "]c", goto_prev = "[c" } })
require("gitsigns").setup({ signcolumn = false })

-- eslint fixes before conform formats
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("kasui92_eslint_fix", { clear = true }),
  callback = function(ev)
    if Kasui92.format.enabled(ev.buf) and #vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" }) > 0 then
      pcall(vim.cmd, "LspEslintFixAll")
    end
  end,
})

-- oxfmt where the project has an oxfmt config, prettier where it has a prettier config, otherwise nothing
local js = { "oxfmt", "prettier", stop_after_first = true }
require("conform").setup({
  default_format_opts = { lsp_format = "never" },
  formatters_by_ft = {
    javascript = js,
    javascriptreact = js,
    typescript = js,
    typescriptreact = js,
    astro = js,
    json = js,
    jsonc = js,
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    markdown = js,
    lua = { "stylua" },
    sh = { "shfmt" },
  },
  formatters = {
    oxfmt = {
      require_cwd = true,
      cwd = require("conform.util").root_file({
        ".oxfmtrc.json",
        ".oxfmtrc.jsonc",
        "oxfmt.config.ts",
        "oxfmt.config.mts",
      }),
    },
    prettier = { condition = Kasui92.format.prettier_has_config },
  },
  format_on_save = function(bufnr)
    if Kasui92.format.enabled(bufnr) then
      return { timeout_ms = 3000 }
    end
  end,
})

local lint = require("lint")
lint.linters_by_ft = { dockerfile = { "hadolint" } }
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("kasui92_lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
