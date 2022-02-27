local utils = require "explorerc.utils"

local M = {}

local cnode_tags = {
  ['keybindings'] = 'keybindings',
  ['language'] = 'language',
  ['plugin'] = 'plugin',
  ['comment'] = 'comment',
  ['what'] = 'what',
  ['why'] = 'why',
  ['generic'] = 'generic'
}

local cnode_icons = {
  [cnode_tags['keybindings']] = '',
  [cnode_tags['language']] = '',
  [cnode_tags['plugin']] = '',
  [cnode_tags['comment']] = '',
  [cnode_tags['what']] = '',
  [cnode_tags['why']] = '',
  [cnode_tags['generic']] = ''
}

M.parse_cnode = function(str, col1, col2, row1, row2)
  local split_str = utils.split(str, '@')

  if utils.len(split_str) ~= 1 then
    local post_delimiter_str = utils.split(split_str[2], " ")
    local tag = post_delimiter_str[1]
    local tag_desc = post_delimiter_str[2]
    local parsed_cnode = M.cnode_factory(tag, tag_desc, col1, col2, row1, row2)

    return parsed_cnode
  else
    local split_raw_str = utils.split(str, ' ')
    local tag = cnode_tags['generic']
    local tag_desc = table.concat(utils.slice(split_raw_str, 2, utils.len(split_raw_str)), " ")

    local parsed_cnode = M.cnode_factory(tag, tag_desc, col1, col2, row1, row2)

    return parsed_cnode
  end
end

M.cnode_factory = function(tag, tag_desc, col1, col2, row1, row2)
  return {
    ['tag'] = tag,
    ['tag_desc'] = tag_desc,
    ['icon'] = M.cnode_icon(tag),
    ['col1'] = col1,
    ['col2'] = col2,
    ['row1'] = row1,
    ['row2'] = row2
  }
end

M.cnode_icon = function(tag)
  if cnode_icons[tag] == nil then
    return ''
  else
    return cnode_icons[tag]
  end
end

local get_leading_spaces = function (depth) 
  local leading_spaces = ''
  for _ = 2, depth do 
    leading_spaces = leading_spaces .. "  " 
  end
  return leading_spaces
end

local get_leader = function (depth)
  return get_leading_spaces(depth)
end

local format_w_leading_zeros = function(num)
  return string.format("%03d", tonumber(num, 10))
end

local get_formatted_desc = function (raw_desc, width, leader_len)
  local available_width = width - leader_len

  if (string.len(raw_desc) > available_width) then
    return string.sub(raw_desc, 0, available_width - 2) .. '...'
  else 
    return string.sub(raw_desc, 0, available_width)
  end
end

-- only show a substring of length of window as description (no wrapping)
M.format_label = function(cnode, index, width)
  local line = format_w_leading_zeros(cnode.row1)

  local separator = '|' .. get_leader(index > 1 and 2 or 1) 

  local leader = line .. separator .. cnode.icon .. ' '

  local desc = get_formatted_desc(cnode.tag_desc, width, string.len(leader))

  return leader .. desc
end

return M
