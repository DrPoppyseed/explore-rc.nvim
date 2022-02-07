local utils = require "explorerc.utils"
local flags = require "explorerc.flags"

local M = {} 

local win_id = nil
local buf = nil

-- window dimensions 
local win_width = vim.api.nvim_get_var("explorerc_win_width")
local win_height = vim.api.nvim_get_var("explorerc_win_height")
local margin_right = vim.api.nvim_get_var("explorerc_margin_right")
local margin_top = vim.api.nvim_get_var("explorerc_margin_top")

local function get_x_pos(width)
  return width - win_width - margin_right
end

local function get_y_pos()
  return margin_top
end

M.create_window = function()
  local ui_stats = vim.api.nvim_list_uis()[1]
  local width = ui_stats.width
  local height = ui_stats.height

  local flags_content = flags.clean_flags(flags.get_raw_flags())

  if win_height == "auto" then
    win_height = height - 4
  end

  buf = vim.api.nvim_create_buf(false, true)
  local opts = {
    relative="win",
    width=win_width,
    height=win_height,
    row=get_y_pos(),
    col=get_x_pos(width),
    border="single",
    style="minimal"
  }

  local current_filename = vim.fn.expand('%')
  local is_valid_file_type = utils.is_valid_file_type(current_filename)

  if is_valid_file_type then
    winId = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_lines(buf, 0, 7, false, flags_content)
  else
    print('error: invalid file format')
  end
end


M.resize_window = function()
  local ui_stats = vim.api.nvim_list_uis()[1]
  local width = ui_stats.width
  local height = ui_stats.height

  -- TODO: get resize to work (especially with window splits)
  if winId == nil and buf == nil then
    print('error: both window and buffer missing.')
  else
    vim.api.nvim_buf_set_opts(buf, "col", get_x_pos(width))
    vim.api.nvim_buf_set_opts(buf, "row", get_y_pos())
  end
end

return M

--[[
"" @plugin superman
"" @comment Thank you!
superman blah blah blah


"" @plugin new extension
yay!

"" @g Remaps

" @plugin Hello
]]
