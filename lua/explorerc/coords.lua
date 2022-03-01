local coords = {
  rel_top = 1,
  rel_row = 1,
  rel_bot = 1,
  abs_top = 1,
  abs_row = 1,
  abs_bot = 1
}

coords.init = function (win_height)
  coords.rel_bot = win_height
  coords.abs_bot = win_height
end

coords.scroll = function (row)
  if row >= coords.abs_bot then
    coords.scroll_down(row)
  else
    coords.scroll_up(row)
  end
end

coords.scroll_up = function (row)
  -- subtract from top and bottom
  coords.abs_row = row
  coords.abs_bot = coords.abs_bot - 1
  coords.abs_top = coords.abs_top - 1
end

coords.scroll_down = function (row)
  -- add top and bottom
  coords.abs_row = row
  coords.abs_bot = coords.abs_bot + 1
  coords.abs_top = coords.abs_top + 1
end

coords.cursor_move = function (row)
  -- TODO: can't handle 'gg' 'G' and other jump movements
  if coords.abs_row < row and coords.rel_row % coords.rel_bot == coords.rel_bot - 1 then
    coords.abs_row = row
  else
    coords.abs_row = row
    coords.rel_row = row - coords.abs_top
  end
end

return coords