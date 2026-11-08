local parsers = {
  "astro",
  "bash",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "kdl",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "php",
  "phpdoc",
  "query",
  "regex",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

-- Parsers compile with the tree-sitter CLI, which mason installs on first start
local function has_cli()
  return vim.fn.executable("tree-sitter") == 1
end
if has_cli() then
  require("nvim-treesitter").install(parsers)
else
  vim.api.nvim_create_autocmd("User", {
    pattern = "MasonToolsUpdateCompleted",
    once = true,
    callback = function()
      require("nvim-treesitter").install(parsers)
    end,
  })
end

local available

local function start(buf, lang)
  if not pcall(vim.treesitter.start, buf) then
    return false
  end
  if #vim.treesitter.query.get_files(lang, "indents") > 0 then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return true
end

-- Highlighting and indent; parsers missing but available get installed on first use
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("kasui92_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or start(ev.buf, lang) or not has_cli() then
      return
    end
    available = available or require("nvim-treesitter").get_available()
    if vim.tbl_contains(available, lang) then
      require("nvim-treesitter").install(lang):await(function()
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ev.buf) then
            start(ev.buf, lang)
          end
        end)
      end)
    end
  end,
})
