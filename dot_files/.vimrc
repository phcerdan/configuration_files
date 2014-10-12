set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Ultisnips (Macros)
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'tomtom/tcomment_vim'
Plugin 'kien/ctrlp.vim'      " Ctrlp to search files
Plugin 'rking/ag.vim'        " Silver searcher
Plugin 'godlygeek/tabular'   " Tabularize :Tabularize /\/\ --Align \\

" Color Schemes
" Plugin 'altercation/vim-colors-solarized'
Plugin 'rainux/vim-desert-warm-256'

" Tmux related:
Plugin 'benmills/vimux' 

"  YouCompleteMe
"Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" COLOUR OPTIONS:
syntax enable
set t_Co=256
set background=dark
" colorscheme solarized 
colorscheme desert-warm-256


" Tmux
" autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
" autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window " . expand("%"))
set title

" BUILT IN OPTIONS:
" Basic
set number
set relativenumber
set autochdir        " Set cd to current file directory.
set pastetoggle=<F11>
set mouse=a          " Automatic enable mouse

" Searching
set ignorecase
set smartcase
set hlsearch   " highlight search
set incsearch  " incremental search

" Tabs and whitespaces
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start

set hid          " Send files to buffer instead of closing them -- e,n ... commands.
set scrolloff=20 " 999 keeps the cursos in the middle.

" General Maps:
let mapleader = ","
imap <c-f> <c-o>2l

" C,C++ specifics:
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.

" Highlight Cursor
:hi CursorLine   cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
" :hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>c :set cursorline!

"let g:EclimCompletionMethod = 'omnifunc'
" For your list of filetypes where you want Eclim semantic completion 
" as the default YCM completion mode:

"autocmd FileType c,cpp,cc,h,hpp  
"    \set completefunc=eclim#c#complete#CodeComplete 

" This will allow you to hit <Enter> in normal mode to search for the
" word under the cursor
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=["bundle/vim-snippets/UltiSnips"]
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<Leader>q" "query ,q


" Latex stuff, latex-suite or vim-latex (UltiSnippets better):
"filetype plugin on
"set grepprg=grep\ -nH\ $*
"filetype indent on
"let g:tex_flavor='latex'
" set paste
