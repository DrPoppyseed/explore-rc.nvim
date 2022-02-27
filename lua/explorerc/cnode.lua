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
    -- handle normal strings without "@" delimiters
    local split_raw_str = utils.split(str, ' ')
    local tag = cnode_tags['generic']
    local tag_desc = ''

    if utils.len(split_raw_str) ~= 1 then
      tag_desc = split_raw_str[2]
    else 
      tag_desc = split_raw_str[1]
    end

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

-- only show a substring of length of window as description (no wrapping)
M.format_label = function(cnode, index, width)
  local line = format_w_leading_zeros(cnode.row1)

  local depth = index > 1 and 2 or 1
  local separator = '|' .. get_leader(depth) 

  local desc = string.sub(cnode.tag_desc, 0, width)

  return line .. separator .. cnode.icon .. ' ' .. cnode.tag_desc
end

return M
