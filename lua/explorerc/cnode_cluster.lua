local tsu = require "nvim-treesitter.ts_utils"
local ts = vim.treesitter
local c = require "explorerc.cnode"

local cnode_cluster = {}

cnode_cluster.create_cluster = function(current_bufnr)
  local cnodes = {}
  local cluster = {}
  local language_tree = ts.get_parser(current_bufnr, 'vim')
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  local query = ts.parse_query('vim', [[
    (comment) @comment
  ]])

  for _, node in query:iter_captures(root, current_bufnr) do
    local text = tsu.get_node_text(node, bufnr)[1]
    local row1, col1, row2, col2 = node:range()
    local parsed_cnode = c.parse_cnode(text, col1, col2, row1, row2)
    cnodes[#cnodes+1]=parsed_cnode
  end

  for index, cnode in pairs(cnodes) do
    if index == 1 then
      cluster[#cluster+1] = cnode_cluster.cluster_node_factory(cnode)
    elseif cnode.row1-1 == cluster[#cluster].range_end then
      local cluster_cnodes = cluster[#cluster].cnodes
      cluster_cnodes[#cluster_cnodes+1] = cnode

      cluster[#cluster] = {
        ['cnodes'] = cluster_cnodes,
        ['range_end'] = cnode['row2'],
      }
    else
      cluster[#cluster+1] = cnode_cluster.cluster_node_factory(cnode)
    end
  end

  return cluster
end

cnode_cluster.cluster_node_factory = function(cnode)
  return {
    ['cnodes'] = {cnode},
    ['range_start'] = cnode.row1,
    ['range_end'] = cnode.row2
  }
end

cnode_cluster.cluster_formatter = function(cluster, width) 
  local flat_cluster = {}
  for _, cluster_node in pairs(cluster) do
    for index, cnode in pairs(cluster_node.cnodes) do 
      flat_cluster[#flat_cluster+1] = c.format_label(cnode, index, width)
    end
  end
  return flat_cluster
end


return cnode_cluster
