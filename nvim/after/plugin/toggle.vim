" quickfix/loc list toggle from vim wiki {{{
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! PreviewWindowOpened()
  for nr in range(1, winnr('$'))
    if getwinvar(nr, "&pvw") == 1
      " found a preview
      return 1
    endif
  endfor
  return 0
endfun

function! ToggleList(bufname, pfx)
  if PreviewWindowOpened() == 1
    exec('pclose')
    return
  endif
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>

" Open qf at bottom
au FileType qf wincmd J | setlocal wrap
au BufWinEnter * if &previewwindow | setlocal wrap | endif
"
" }}}
