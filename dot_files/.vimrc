set nocompatible              " be iMproved, required
filetype off                  " required
let mapleader=","
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'


" Ultisnips (Macros)
Plugin 'SirVer/ultisnips'                 " Awesomeness. Create your own snippets
Plugin 'honza/vim-snippets'

" Supertab Use tab to auto-complete, Ctrl-E to return to original without auto-complete
Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
" set wildmode=list:longest,full
" let g:SuperTabClosePreviewOnPopupClose = 1 " close scratch window on autocompletion "

" Align and Tabularize:
Plugin 'godlygeek/tabular'                " Tabularize :Tabularize /\/\ --Align \\
Plugin 'vim-scripts/Align'                " Tabularize is better, but it is requisite for autoalign
Plugin 'vim-scripts/AutoAlign' 

Plugin 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plugin 'tpope/vim-dispatch'               " Async building. :Make, :Make!, Dispatch for running things.https://github.com/tpope/vim-dispatch
Plugin 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
Plugin 'tpope/vim-surround'               " cs\"' to change \" for ', or yss) putting the sentence into brackets. The first s is for surround.
Plugin 'tpope/vim-obsession'              " Save/restore sessions :Obsess, :Obsess!, and vim -S, or :source to restore. Also used by tmux-resurrect
Plugin 'dhruvasagar/vim-prosession'       " :Prosession, save session to .vim/session

Plugin 'tomtom/tcomment_vim'              " gcc to comment sentence, gc$, etc.

" File Navigation and Search:
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'                   " Ctrlp to search for / open files
Plugin 'rking/ag.vim'                     " Silver searcher integration (similar to ack / grep), search in directory for words. To install silver_searcher: https://github.com/ggreer/the_silver_searcher

" Status Line Plugins
Plugin 'bling/vim-airline'                " Colourful status-line.
Plugin 'edkolev/tmuxline.vim'             " Status line for tmux (Airline compatible)

" Color Schemes
Plugin 'rainux/vim-desert-warm-256'
"Language specifics Plugins
Plugin 'LaTeX-Box-Team/LaTeX-Box'         " Minimalistic. ll to compile, lv to view. Xpdf recommended.
Plugin 'octol/vim-cpp-enhanced-highlight' " Cpp improved highlight
" Plugin 'Townk/vim-autoclose'
" inoremap {<CR> {<CR>}<C-o>O}
Plugin 'Raimondi/delimitMate'

Plugin 'ntpeters/vim-better-whitespace'
let g:better_whitespace_filetypes_blacklist=['unite'] " ignore in help files and similar
" Plugin 'nathanaelkane/vim-indent-guides'
" Eclim has a special installation: http://eclim.org/install.html and
" dotfile: .eclimrc

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" COLOUR OPTIONS:
syntax enable
set t_Co=256
set background=dark
colorscheme desert-warm-256
setlocal spell spelllang=en_us
set nospell

" Tmux
" autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
" autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window " . expand("%"))
set title
set diffopt+=vertical " Gdiff open in vertical.
set splitright
set splitbelow

" BUILT IN OPTIONS:
" Basic
set number
set relativenumber
set autochdir        " Set cd to current file directory.
set pastetoggle=<F8> " Paste without autoindent
set mouse=a          " Automatic enable mouse
set textwidth=0
set wrapmargin=0     " Turns off physical line wrapping (automatic insertion of newlines)
"set nowrap         " No visual wrapping
set laststatus=2     " Status line always visible (useful with vim-airline)
set wrapscan         " Search next/ Search previous are cyclic.
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
" To navigate trough visually wrapped lines.
nnoremap j gj
nnoremap k gk
" To keep the old behavior in gj, gk
nnoremap gj j
nnoremap gk k
" To use with bracketing/indendation with brackets.
imap <c-F> <C-g>g
inoremap <c-k> <ESC>kI<TAB>
inoremap <c-h> <c-o>h
" C,C++ specifics:
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.

" Highlight Cursor
:hi CursorLine   cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>c :set cursorline!<CR>

" If you want :UltiSnipsEdit to split your window
" set runtimepath+=~/.dotfiles
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['UltiSnips',"bundle/vim-snippets/UltiSnips"]
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<Leader>q" "query ,q

" Latex-box:
let g:LatexBox_latexmk_async=1 " Require gvim --servername vimserver main.tex
let g:LatexBox_latexmk_preview_continuosly=1 " -pvc option in latexmk
let g:LatexBox_viewer="xpdf"
let g:LatexBox_latexmk_options="-pdflatex='pdflatex -synctex=1 \%O \%S'"
syntax spell toplevel
let g:tex_comment_nospell=1

" vim-Airline:
let g:airline_theme='wombat'
let g:airline#extensions#tabline#enabled = 1 "Show tabs if only one is enabled.
" vim-tmuxline
let g:tmuxline_powerline_separators = 0

" Cpp highlighting:
" let g:cpp_class_scope_highlight = 1

" Eclim
let g:EclimLogLevel                    = 'debug'
let g:EclimDefaultFileOpenAction       = 'vsplit'
let g:EclimCSearchSingleResult         = 'vsplit'
let g:EclimBuffersDefaultAction        = 'vsplit'
let g:EclimLocateFileDefaultAction     = 'vsplit'
let g:EclimCCallHierarchyDefaultAction ='vsplit'
autocmd VimEnter * if exists(":CSearchContext") | exe "nnoremap <silent> <buffer> <cr> :CSearchContext<cr>" | endif

"CtrlP and Ag
if executable('ag')
" Use Ag over Grep
set grepprg=ag\ --nogroup\ --nocolor
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
endif
let g:ctrlp_custom_ignore = '\v[\/](cache|cached)|(\.(swp|ico|git|svn))$'

function! StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
    echo "Trailing whitespace stripped\n"
  endif
  normal `Z
endfunction
autocmd BufWritePre *.cpp,*.hpp,*.h,*.c :call StripTrailingWhitespace()

if version >= 702
  autocmd BufWinLeave * call clearmatches() " Solve performance problems with multiple syntax match.
endif

" Keep the last cursor position: http://stackoverflow.com/questions/8854371/vim-how-to-restore-the-cursors-logical-and-physical-positions
" Create a folder ~/.vim/view
" au BufWinLeave *.tex, *.c, *.cpp, *.h, *.hpp mkview
" au VimEnter *.tex,*.c,*.cpp,*.h,*.hpp loadview

" Set makeprg to closest build folder (Cmake builds)
function! SetMakeprg()

    if !empty(glob("../build"))
        set makeprg=make\ -C\ ../build
        return
    endif
    if !empty(glob("../build-debug"))
        set makeprg=make\ -C\ ../build-debug
        return
    endif

    if !empty(glob("../../build"))
        set makeprg=make\ -C\ ../../build
        return
    endif

    if !empty(glob("../../build-debug"))
        set makeprg=make\ -C\ ../../build-debug
        return
    endif
endfunction
au FileType c,cpp call SetMakeprg()
