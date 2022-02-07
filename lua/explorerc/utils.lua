local utils = {}

-- code gist from https://gist.github.com/qizhihere/cb2a14432d9bf65693ad
-- STARTS HERE {{{
local function table_clone_internal(t, copies)
  if type(t) ~= "table" then return t end
  
  copies = copies or {}
  if copies[t] then return copies[t] end

  local copy = {}
  copies[t] = copy

  for k, v in pairs(t) do
    copy[table_clone_internal(k, copies)] = table_clone_internal(v, copies)
  end

  setmetatable(copy, table_clone_internal(getmetatable(t), copies))

  return copy
end

utils.table_clone = function(t)
  -- We need to implement this with a helper function to make sure that
  -- user won't call this function with a second parameter as it can cause
  -- unexpected troubles
  return table_clone_internal(t)
end

utils.table_merge = function(...)
  local tables_to_merge = {...}
  assert(#tables_to_merge > 1, "There should be at least two tables to merge them")

  for k, t in ipairs(tables_to_merge) do
    assert(type(t) == "table", string.format("Expected a table as function parameter %d", k))
  end

  local result = utils.table_clone(tables_to_merge[1])

  for i = 2, #tables_to_merge do
    local from = tables_to_merge[i]
    for k, v in pairs(from) do
      if type(v) == "table" then
        result[k] = result[k] or {}
        assert(type(result[k]) == "table", string.format("Expected a table: '%s'", k))
        result[k] = utils.table_merge(result[k], v)
      else
      result[k] = v
      end
    end
  end

  return result
end
-- }}} ENDS HERE

utils.split = function(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

utils.center_text = function(str)
  local width = vim.api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

utils.trim = function(str)
  return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

utils.tablelength = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

utils.is_valid_file_type = function(filename)
  local split_filename = utils.split(filename, '/')
  local tail = split_filename[#split_filename]
  -- TODO: remove lua$ later
  return string.match(tail, 'rc$') or string.match(tail, 'lua$')
end

return {
  table_clone = table_clone,
  table_merge = table_merge,
}


return utils
