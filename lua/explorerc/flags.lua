local utils = require "explorerc.utils"

local flags = {}

flags.get_raw_flags = function()
  local file = vim.treesitter
  local buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local raw_flags = {}
  for index, value in pairs(buf) do
    if string.find(value, '\"\" @') then
      local line = utils.split(value, "@")
      local flag_line = index
      local flag_title = utils.split(line[2], " ")[1]
      local flag_content = utils.trim(utils.split(line[2], flag_title)[2])
      table.insert(raw_flags, {flag_line, flag_title, flag_content})
    end
  end 

  return raw_flags
end

flags.add_icon = function(flag_type)
  local default_icons = {
    ['plugin'] = '',
    ['comment'] = '',
    ['what'] = '',
    ['why'] = '',
    ['g'] = ''
  }

  local custom_icons = vim.api.nvim_get_var('explorerc_custom_icons')

  local merged_icons = utils.table_merge(default_icons, custom_icons)

  if merged_icons[flag_type] == nil then
    return ''
  else
    return icons[flag_type]
  end
end

flags.format_line = function(flag)
  return flag[1] .. '| ' .. flags.add_icon(flag[2]) ..  ' ' .. flag[3]
end



flags.clean_flags = function(raw_table)
  local clean_table = {}
  for _, value in pairs(raw_table) do
    table.insert(clean_table, flags.format_line(value))
  end
  return clean_table
end


return flags
