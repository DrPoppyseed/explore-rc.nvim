" Get config values from vimrc
if !exists('g:explorerc_win_height')  
  let g:explorerc_win_height = 16
endif

if !exists('g:explorerc_win_width')  
  let g:explorerc_win_width = 32
endif

if !exists('g:explorerc_margin_right')
  let g:explorerc_margin_right = 4
endif

if !exists('g:explorerc_margin_top')
  let g:explorerc_margin_top = 4
endif

if !exists('g:explorerc_custom_icons')
  let g:explorerc_custom_icons = {}
endif

function! ExploreRC()
  lua for k in pairs(package.loaded) do if k:match('^explorerc') then package.loaded[k] = nil end end
  lua require('explorerc').create_window()
endfunction

augroup ExploreRC
  autocmd!
  autocmd BufHidden * lua require('explorerc').on_rc_close()
augroup END
