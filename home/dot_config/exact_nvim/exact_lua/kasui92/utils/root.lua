-- Project root: nearest dir with .git or package.json above the buffer, cwd otherwise
return function(bufnr)
  return vim.fs.root(bufnr or 0, { ".git", "package.json" }) or vim.fn.getcwd()
end
