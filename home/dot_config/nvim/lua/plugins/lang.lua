-- TypeScript major version installed for the buffer's project, 0 if none
local function ts_major(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  local pkg = vim.fs.find("node_modules/typescript/package.json", { upward = true, path = dir })[1]
  if not pkg then
    return 0
  end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
  return ok and tonumber(tostring(data.version):match("^(%d+)")) or 0
end

-- Config table from nvim-lspconfig's own lsp/<name>.lua
local function upstream(name)
  for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/" .. name .. ".lua", true)) do
    if file:find("nvim-lspconfig", 1, true) then
      return dofile(file)
    end
  end
end

-- Mason packages left out: no host php, no markdownlint
local mason_skip = { phpcs = true, ["php-cs-fixer"] = true, ["markdownlint-cli2"] = true }

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Native tsc LSP in TypeScript 7 projects, vtsls in older ones
      local vtsls = upstream("vtsls")
      -- root_dir and cmd share the binary cache of one module instance
      local tsc = upstream("tsc")
      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.root_dir = function(bufnr, on_dir)
        if ts_major(bufnr) < 7 then
          vtsls.root_dir(bufnr, on_dir)
        end
      end
      opts.servers.tsc = {
        enabled = true,
        mason = false,
        cmd = tsc.cmd,
        root_dir = function(bufnr, on_dir)
          if ts_major(bufnr) >= 7 then
            tsc.root_dir(bufnr, on_dir)
          end
        end,
        settings = {
          ["js/ts"] = {
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      }

      -- PHP 8.4 like the containers, no intelephense formatting
      opts.servers.intelephense = vim.tbl_deep_extend("force", opts.servers.intelephense or {}, {
        settings = {
          intelephense = {
            environment = { phpVersion = "8.4.0" },
            format = { enable = false },
          },
        },
      })

      opts.servers.tailwindcss = opts.servers.tailwindcss or {}
      opts.servers.tailwindcss.filetypes_exclude = { "markdown", "php" }

      -- Show which tool and rule raised each diagnostic
      opts.diagnostics.virtual_text.source = false
      opts.diagnostics.virtual_text.format = function(d)
        if d.source and d.code then
          return ("%s (%s: %s)"):format(d.message, d.source, d.code)
        elseif d.source then
          return ("%s (%s)"):format(d.message, d.source)
        end
        return d.message
      end
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.php = {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- oxfmt only in projects with an oxfmt config
      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = {
        require_cwd = true,
        cwd = require("conform.util").root_file({
          ".oxfmtrc.json",
          ".oxfmtrc.jsonc",
          "oxfmt.config.ts",
          "oxfmt.config.mts",
        }),
      }
      opts.formatters_by_ft.php = {}
      opts.formatters_by_ft.markdown = { "prettier", "markdown-toc" }
      opts.formatters_by_ft["markdown.mdx"] = { "prettier", "markdown-toc" }
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return not mason_skip[pkg]
      end, opts.ensure_installed)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kdl" } },
  },

  -- No chezmoi apply on save of source files
  { "xvzc/chezmoi.nvim", init = function() end },

  {
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      vim.g["chezmoi#source_dir_path"] = vim.env.HOME .. "/.local/share/chezmoi/home"
    end,
  },
}
