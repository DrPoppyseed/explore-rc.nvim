local utils = require "explorerc.utils"
local cnode_cluster = require "explorerc.cnode_cluster"

local M = {} 

local buf = nil
-- local rc_bufnr = -1
local rc_win = -1

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

M.goto_cnode = function()
  local current_line = vim.api.nvim_get_current_line()
  local row_number = utils.split(current_line, "|")[1]

  vim.api.nvim_set_current_win(rc_win)
  vim.api.nvim_command(':' .. row_number+1)
end

M.create_window = function()
  local ui_stats = vim.api.nvim_list_uis()[1]
  local width = ui_stats.width
  local height = ui_stats.height

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
    -- rc_bufnr = vim.api.nvim_get_current_buf()
    local cluster = cnode_cluster.create_cluster(bufnr)
    local flat = cnode_cluster.cluster_formatter(cluster, win_width)

    print(vim.inspect(flat))

    rc_win = vim.api.nvim_get_current_win()
    vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, flat)

    utils.map("n", "<cr>", ":lua require('explorerc').goto_cnode()<cr>")
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
