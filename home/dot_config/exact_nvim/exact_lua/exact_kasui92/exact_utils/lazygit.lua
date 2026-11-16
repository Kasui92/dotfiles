local M = {}

-- Window lazygit was opened from; files edited in lazygit open there
local origin_win

function M.open()
  origin_win = vim.api.nvim_get_current_win()
  Snacks.lazygit()
end

function M.focus_origin()
  if origin_win and vim.api.nvim_win_is_valid(origin_win) then
    pcall(vim.api.nvim_set_current_win, origin_win)
  end
end

-- lazygit os.edit / os.editAtLine (sh): inside nvim quits lazygit and opens the file in the
-- origin window through $NVIM, outside runs nvim
function M.edit_command(at_line)
  local server = 'nvim --server "$NVIM"'
  local inside = {
    server .. ' --remote-send "q"',
    server .. [[ --remote-send '<Cmd>lua Kasui92.lazygit.focus_origin()<CR>']],
    server .. " --remote {{filename}}",
  }
  local outside = "nvim -- {{filename}}"
  if at_line then
    inside[#inside + 1] = server .. [[ --remote-send '<Cmd>{{line}}<CR>']]
    outside = "nvim +{{line}} -- {{filename}}"
  end
  return ('if [ -z "$NVIM" ]; then %s; else %s; fi'):format(outside, table.concat(inside, "; "))
end

return M
