local a = vim.api

local mappings = {}

mappings.set_mappings = function (buf)
  local defaults = {
    ['<cr>'] = 'goto_cnode()',
    ['<2-LeftMouse>'] = 'goto_cnode()',
  }

  for k,v in pairs(defaults) do
    a.nvim_buf_set_keymap(buf, 'n', k, ':lua require"explorerc".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end
end

return mappings
