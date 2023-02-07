au FileType qf nnoremap <silent> <leader>x :AnsiEsc<CR>
com! -nargs=1 -complete=file BuildFolder let g:buildFolder=fnamemodify(<q-args>, ':p') <bar> let g:testFolder=fnamemodify(<q-args>, ':p')
com! -nargs=1 BuildTarget let g:buildTarget=<q-args>
let g:debugArgs=''
com! -nargs=1 DebugArgs let g:debugArgs=<q-args>

nnoremap <silent> <Leader>n :execute "AsyncRun! " . NinjaString()<CR> <bar> let g:bCommand = 'ninja'<CR>

function! NinjaString()
  let lst = 'ninja -C ' . g:buildFolder
  if exists("g:buildTarget")
    let lst = lst . ' ' . g:buildTarget
  endif
  return lst
endfunction

function! ErrorFormatCMake()
  let efmt =
        \ '%-DDIR : %f,%-XENDDIR : %f,' .
        \ '%-G,' .
        \ '%+G-- %.%#,' .
        \ '%E%>CMake Error at %f:%l (%[%^)]%#):,' .
        \ '%Z  %m,' .
        \ '%E%>CMake Error: Error in cmake code at,' .
        \ '%C%>%f:%l:,' .
        \ '%Z%m,' .
        \ '%E%>CMake Error in %.%#:,' .
        \ '%C%>  %m,' .
        \ '%C%>,' .
        \ '%C%>    %f:%l (if),' .
        \ '%C%>,' .
        \ '%Z  %m,'
  return efmt
endfunction

function! ErrorFormatClang()
  let efmt =
        \ '%-G%f:%s:,' .
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m,' .
        \ '%I%f:%l:%c: note: %m,' .
        \ '%f:%l:%c: %m,'.
        \ '%f:%l: %trror: %m,'.
        \ '%f:%l: %tarning: %m,'.
        \ '%I%f:%l: note: %m,'.
        \ '%f:%l: %m'
  return efmt
endfunction

function! ErrorFormatGCC()
  let efmt =
        \ '%-G%f:%s:,' .
        \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
        \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
        \ '%-GIn file included%.%#,' .
        \ '%-G %#from %f:%l\,,' .
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m,' .
        \ '%I%f:%l:%c: note: %m,' .
        \ '%f:%l:%c: %m,' .
        \ '%f:%l: %trror: %m,' .
        \ '%f:%l: %tarning: %m,'.
        \ '%I%f:%l: note: %m,'.
        \ '%f:%l: %m'
  return efmt
endfunction
function! ErrorFormatJavascriptJest()
  " From https://github.com/craigdallimore/vim-jest-cli/blob/master/compiler/jest-cli.vim
  let efmt = '%.%#\ at\ %f:%l:%c,%.%#\ at\ %.%#(%f:%l:%c)'
  return efmt
endfunction

augroup FileType javascript
  let &errorformat=ErrorFormatJavascriptJest()
augroup end


function! SetErrorFormatClang()
  let &errorformat = ErrorFormatClang() . ',' . ErrorFormatCMake()
endfunction

function! SetErrorFormatGCC()
  let &errorformat = ErrorFormatGCC() . ',' . ErrorFormatCMake()
endfunction

augroup FileType cpp
  call SetErrorFormatGCC()
augroup end
