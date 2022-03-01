local a = vim.api
local u = require "explorerc.utils"

local window = {
  win = nil,
  buf = nil,
  parent_win_width = nil,
  win_width = a.nvim_get_var("explorerc_win_width"),
  win_height = a.nvim_get_var("explorerc_win_height"),
  margin_right = a.nvim_get_var("explorerc_margin_right"),
  margin_top = a.nvim_get_var("explorerc_margin_top")
}

-- get window dimesions
window.get_window_x_pos = function (parent_window_width)
  return parent_window_width - window.win_width - window.margin_right
end

window.get_window_y_pos = function ()
  return window.margin_top
end

window.get_ui_stats = function ()
  local ui_stats = a.nvim_list_uis()[1]
  local width = ui_stats.width
  window.parent_win_width = width
end

-- create new window
window.create_window = function ()
  window.get_ui_stats()

  window.buf = a.nvim_create_buf(false, true)

  window.win = a.nvim_open_win(window.buf, true, {
    relative="win",
    width=window.win_width,
    height=window.win_height,
    row=window.get_window_y_pos(),
    col=window.get_window_x_pos(window.parent_win_width),
    border="single",
    style="minimal"
  })

  --  Configure buffer options
  a.nvim_buf_set_option(window.buf, 'buftype', 'nofile')
  a.nvim_buf_set_option(window.buf, 'swapfile', false)
  a.nvim_buf_set_option(window.buf, 'bufhidden', 'wipe')
  a.nvim_buf_set_option(window.buf, 'filetype', 'nvim-oldfile')

  -- Configure window options
  a.nvim_win_set_option(window.win, 'wrap', false)
  a.nvim_win_set_option(window.win, 'cursorline', true)
end

return window