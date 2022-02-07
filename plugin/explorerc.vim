if exists('g:loaded_explorerc') || !has('nvim')
  finish
endif
let g:loaded_explorerc = 1

" Get config values from vimrc
if !exists('g:explorerc_win_height')  
  let g:explorerc_win_height = 8
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

command! -bar -nargs=*
      \ ExploreRC 
      \ lua require('explorerc').create_window()

" autocmd VimResized * lua require('explorerc').resize_window()
