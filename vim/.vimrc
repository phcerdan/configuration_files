set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" YouCompleteMe
"Plugin 'Valloric/YouCompleteMe'

" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" set paste
set number
set relativenumber
syntax on
set ignorecase
set smartcase
set autochdir
set sw=4
set hid " Send files to buffer instead of closing them -- e,n ... commands.
set backspace=indent,eol,start
imap <c-f> <c-o>2l
"let g:EclimCompletionMethod = 'omnifunc'
" For your list of filetypes where you want Eclim semantic completion 
" as the default YCM completion mode:

"autocmd FileType c,cpp,cc,h,hpp  
"    \set completefunc=eclim#c#complete#CodeComplete 

" This will allow you to hit <Enter> in normal mode to search for the
" word under the cursor
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["~/.vim/bundle/vim-snippets/UltiSnips"]
