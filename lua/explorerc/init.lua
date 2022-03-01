local a = vim.api
local f = vim.fn
local c = require "explorerc.coords"
local w = require "explorerc.window"
local u = require "explorerc.utils"
local m = require "explorerc.mappings"
local cnode_cluster = require "explorerc.cnode_cluster"

local init = {}

local rc_win = nil

init.goto_cnode = function()
  local current_line = a.nvim_get_current_line()
  local row_number = u.split(current_line, "|")[1] + 1

  a.nvim_set_current_win(rc_win)
  a.nvim_command(':' .. row_number)
end

init.create_window = function()
  local cluster = cnode_cluster.create_cluster(bufnr)
  local flat = cnode_cluster.cluster_formatter(cluster, w.win_width)

  c.init(w.win_height)

  if u.is_valid_file_type(f.expand('%')) then
    rc_win = a.nvim_get_current_win()
    w.create_window()
    a.nvim_buf_set_lines(w.buf, 0, 1, false, flat)
    m.set_mappings(w.buf)
  else
    print('error: invalid file format')
  end
end

init.on_close = function ()
  if rc_win ~= nil and w.win ~= nil then
    a.nvim_win_close(w.win, true)
    w.win = nil
  end
end

init.resize_window = function ()
  w.get_ui_stats()
  -- TODO: get resize to work (especially with window splits)
  if w.win == nil or w.buf == nil then
    print('error: both window and buffer missing.')
  else
    a.nvim_buf_set_opts(w.buf, "col", w.get_window_x_pos(w.parent_win_width))
    a.nvim_buf_set_opts(w.buf, "row", w.get_window_y_pos())
  end
end

init.on_cursor_move = function ()
  if w.win == a.nvim_get_current_win() then
    local pos = a.nvim_win_get_cursor(w.win)
    c.cursor_move(pos[1])
  end
end

init.on_scroll = function ()
  if w.win == a.nvim_get_current_win() then
    local pos = a.nvim_win_get_cursor(w.win)
    c.scroll(pos[1])
  end
end

return init