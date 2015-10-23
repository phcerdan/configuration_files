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
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['UltiSnips',"bundle/vim-snippets/UltiSnips"]
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<Leader>q" "query ,q

" Supertab Use tab to auto-complete, Ctrl-E to return to original without auto-complete
Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
" set wildmode=list:longest,full
" let g:SuperTabClosePreviewOnPopupClose = 1 " close scratch window on autocompletion "

Plugin 'Raimondi/delimitMate'             " Auto-pair like script
Plugin 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plugin 'tpope/vim-dispatch'               " Async building. :Make, :Make!, Dispatch for running things.https://github.com/tpope/vim-dispatch
Plugin 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
Plugin 'tpope/vim-surround'               " cs\"' to change \" for ', or yss) putting the sentence into brackets. The first s is for surround.
Plugin 'tpope/vim-obsession'              " Save sessions :Obsess, Restore: vim -S, or :source . Also used by tmux-resurrect
Plugin 'tpope/vim-commentary'             " gcc to comment sentence, gc$, etc.
au FileType cmake setlocal commentstring=#\ %s
Plugin 'tpope/vim-abolish'                " substitutions with plurals, cases, etc.
Plugin 'tpope/vim-repeat'                 " repeat commands(normal mode) with .
Plugin 'vim-scripts/visualrepeat'         " works with visual mode too.

Plugin 'ntpeters/vim-better-whitespace'   " Highlight whitespaces and provide StripWhiteSpaces()
let g:better_whitespace_filetypes_blacklist=['unite'] " ignore in help files and similar

" Align and Tabularize:
Plugin 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
Plugin 'Yggdroot/indentLine'
let g:indentLine_char = '|'
" let g:indentLine_leadingSpaceChar = '.'
" let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_faster = 1
let g:indentLine_color_term = 239
let g:indentLine_enabled = 1

" File Navigation and Search:
Plugin 'scrooloose/nerdtree'              " Folder structure viewer
Plugin 'kien/ctrlp.vim'                   " Ctrlp to search for / open files
nnoremap <Leader>t :CtrlPTag<cr>
Plugin 'rking/ag.vim'                     " Silver searcher integration (similar to ack / grep), search in directory for words. To install silver_searcher: https://github.com/ggreer/the_silver_searcher
Plugin 'emnh/taglist.vim'                 " Most up-voted plugin ever, works great with ctags.
nnoremap <silent> <F9> :TlistToggle<cr>
" Color Schemes
Plugin 'rainux/vim-desert-warm-256'
Plugin 'bling/vim-airline'                " Colourful status-line.
let g:airline_theme='wombat'
let g:airline#extensions#tabline#enabled = 1 "Show tabs if only one is enabled.
" To show full path: default is %f instead of %F.
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_powerline_fonts = 1
" TMUX
Plugin 'edkolev/tmuxline.vim'             " Status line for tmux (Airline compatible)
let g:tmuxline_powerline_separators = 1
Plugin 'christoomey/vim-tmux-navigator'   " Navigating vim/tmux with same keys. Default keys are <c-hjkl>
" Buffers control
Plugin 'vim-scripts/BufOnly.vim'          " :BOnly deltes all buffers except current one.
Plugin 'moll/vim-bbye'                    " Bdelete, as Bclose, deleting buffers without deleting windows.
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
nnoremap <Leader>bd :Bdelete<CR>
" Close buffer and window (split)
noremap <Leader>q :Bclose<CR><c-W>c
"Language specifics Plugins
""""""LATEX """""
Plugin 'LaTeX-Box-Team/LaTeX-Box'         " Minimalistic. ll to compile, lv to view. Xpdf/Zathura recommended.
Plugin 'octol/vim-cpp-enhanced-highlight' " Cpp improved highlight
" Plugin 'Townk/vim-autoclose'
" inoremap {<CR> {<CR>}<C-o>O}
Plugin 'vim-scripts/DoxygenToolkit.vim'
" Eclim has a special installation: http://eclim.org/install.html and
" dotfile: .eclimrc

"""""""" R """""""""""":
Plugin 'jalvesaq/VimCom'      " Communication vim - R
" install.packages("~/.vim/bundle/VimCom", type = "source", repos = NULL)
Plugin 'jalvesaq/R-Vim-runtime'
Plugin 'jcfaria/Vim-R-plugin' " Too many <Leader> shortcuts???
" Recommended in R:
" colourout and set with
" download.file("http://www.lepem.ufc.br/jaa/colorout_1.1-0.tar.gz", destfile= "colorout_1.1-0.tar.gz")
" install.packages("colorout_1.1-0.tar.gz", type = "source", repos = NULL)
"  download.file("http://cran.r-project.org/src/contrib/setwidth_1.0-3.tar.gz", destfile= "setwidth_1.0-3.tar.gz")
" install.packages("setwidth_1.0-3.tar.gz", type = "source", repos = NULL)
let vimrplugin_notmuxconf = 1 " To use your own tmux.conf
let vimrplugin_latexcmd = "~/devtoolset/texlive/2014/bin/x86_64-lqnux/latexmk"
" let vimrplugin_assign = "<Leader>_"     " To avoid replacement from _ to <-, to disable = 0
let vimrplugin_r_path = "~/devtoolset/R/bin"
"""""""" Python """"""""""
" Plugin 'klen/python-mode'
""""""""""CUDA""""""""""""
Plugin 'cmaureir/snipmate-snippets-cuda' " snippets and simple syntax.
" Create a symlink inside vim-snippets/snippets pointing to
" snipmate-snippets-cuda/snippets/cu.snippets, and rename it as cuda.snippets.
au BufNewFile,BufRead *.cu  setlocal ft=cuda.cpp
""""""" Rails (Ruby) """":
" Plugin 'tpope/vim-rails'
"""""""AUTCOMPLETERS"""""
" Installed without Clang
Plugin 'Valloric/YouCompleteMe'
" Compiling required after plugin download:
" cd ~/.vim/plugin/YouCompleteMe ; ./install.py
" cd ~/.vim/plugin/YouCompleteMe ; ./install.py --clang-completer (Not recommended)
" Plugin 'rdnetto/YCM-Generator'  " Generate yconf_* per project based on cmake (weak)
" ctags must be called with --fields=+l (modified in git_templates/ctags)
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'  " This overrides the default 'Context' for SuperTab+UltiSnips+Eclim
let g:SuperTabCrMapping = 0
let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" disable load ycm if no clang in the path.
" if executable('clang')
" else
"     let g:loaded_youcompleteme = 1
" endif

call vundle#end()            " required

filetype plugin indent on    " required

" COLOUR OPTIONS:
syntax enable
set t_Co=256
set background=dark
colorscheme desert-warm-256
setlocal spell spelllang=en_us
set nospell
map <F12> :setlocal spell! spelllang=en_us<CR>
set title
set diffopt+=vertical " Gdiff open in vertical.
set splitright
set splitbelow
set timeoutlen=500 " timeoutlen : time to wait for chain character (leader, etc) Default is 1000, 1 sec

" BUILT IN OPTIONS:
" Basic
set number           " Show line numbers
set relativenumber   " In relative way
set autochdir        " Set cd to current file directory.
set pastetoggle=<F8> " Paste without autoindent
set mouse=a          " Automatic enable mouse
set textwidth=0
set wrapmargin=0     " Turns off physical line wrapping (automatic insertion of newlines)
set laststatus=2     " Status line always visible (useful with vim-airline)
set wrapscan         " Search next/ Search previous are cyclic.
" set clipboard=autoselect,unnamed,unnamedplus,exclude:cons\|linux  " Clipboard is copied to unnamed register (")
set clipboard+=unnamedplus
" au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak breakindent showbreak=..
au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak showbreak=..
" Searching
set ignorecase " ignore case
set smartcase  " expcept when there is a case on the query
set hlsearch   " highlight search
set incsearch  " incremental search
set hid          " Send files to buffer instead of closing them -- e,n ... commands.
set scrolloff=20 " 999 keeps the cursos in the middle.
" Autocomplete window: show preview win, show menu with 1 match, insert longest match
set completeopt=preview,menuone,longest

" Tabs and whitespaces
set autoindent
set backspace=indent,eol,start
set expandtab
" set matchpairs+=<:>

set tabstop=4
set shiftwidth=4
set softtabstop=4
command! Indent2 set tabstop=2 | set shiftwidth=2 | set softtabstop=2
command! Indent4 set tabstop=4 | set shiftwidth=4 | set softtabstop=4
command! Indent8 set tabstop=8 | set shiftwidth=8 | set softtabstop=8
command! Indent2L setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal softtabstop=2
command! Indent4L setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal softtabstop=4
command! Indent8L setlocal tabstop=8 | setlocal shiftwidth=8 | setlocal softtabstop=8
command! IndentITK execute 'Indent2' | set cinoptions={1s,:0,l1,g0,c0,(0,(s,m1
" Template files.
au BufNewFile,BufRead *.txx setlocal ft=cpp
" Git commits:
autocmd Filetype gitcommit setlocal spell textwidth=72
" Recognize Markdown.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

""""""""" General Maps: """""""""""""""""
" To navigate trough visually wrapped lines.
nnoremap j gj
nnoremap k gk
" To keep the old behavior in gj, gk
nnoremap gj j
nnoremap gk k
" To use with bracketing/indendation with brackets.
imap <c-F> <C-g>g
inoremap <Leader>k <ESC>kI<TAB>
inoremap <Leader>h <c-o>h
" " C,C++ specifics:
" use ]f [f from Unimpaired instead
" map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.

" Highlight Cursor
:hi CursorLine   cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>cl :set cursorline!<CR>

" Latex-box:
let g:LatexBox_latexmk_async=1 " Require gvim --servername vimserver main.tex
let g:LatexBox_latexmk_preview_continuosly=1 " -pvc option in latexmk
let g:LatexBox_viewer="xpdf"
if executable('zathura')
    let g:LatexBox_viewer="zathura"
endif
let g:LatexBox_latexmk_options="-pdflatex='lualatex -synctex=1 -shell-escape \%O \%S'"
syntax spell toplevel
let g:tex_comment_nospell=1
" To save automatically when using <LocalLeader>ll
autocmd BufNewFile,BufRead *.tex nnoremap <buffer> <LocalLeader>ll :update<CR>:Latexmk<CR>

" Eclim
let g:EclimLogLevel                    = 'debug'
" let g:EclimDefaultFileOpenAction       = 'vsplit'
" let g:EclimCSearchSingleResult         = 'vsplit'
" let g:EclimBuffersDefaultAction        = 'vsplit'
" let g:EclimLocateFileDefaultAction     = 'vsplit'
" let g:EclimCCallHierarchyDefaultAction = 'vsplit'
let g:EclimKeepLocalHistory            = 1
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimFileTypeValidate = 0 " Avoid validation on save (memory expensive)
nnoremap <silent> <buffer> <cr> :CSearchContext<cr>

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
" autocmd FileType c,cpp autocmd BufWritePre <buffer> StripWhitespace
au FileType c,cpp au BufWritePre * call StripTrailingWhitespace()

if version >= 702
  autocmd BufWinLeave * call clearmatches() " Solve performance problems with multiple syntax match.
endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close, in ~/.viminfo
set viminfo^=%

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying https://amix.dk/vim/vimrc.html
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>
" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>
" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set makeprg to closest build folder (Cmake builds)
function! SetMakeprg()
      if !empty($NUMBER_OF_PROCESSORS)
        " this works on Windows and provides a convenient override mechanism otherwise
        let n = $NUMBER_OF_PROCESSORS + 0
      elseif filereadable('/proc/cpuinfo')
        " this works on most Linux systems
        let n = system('grep -c ^processor /proc/cpuinfo') + 0
      elseif executable('/usr/sbin/psrinfo')
        " this works on Solaris
        let n = system('/usr/sbin/psrinfo -p')
      else
        " default to single process if we can't figure it out automatically
        let n = 1
      endif

    if !empty(glob("../build"))
        let buildFolder='../build'
    elseif !empty(glob("../build-debug"))
        let buildFolder='../build-debug'
    elseif !empty(glob("../build-release"))
        let buildFolder='../build-release'
    elseif !empty(glob("../../build"))
        let buildFolder='../../build'
    elseif !empty(glob("../../build-debug"))
        let buildFolder='../../build-debug'
    elseif !empty(glob("../../build-release"))
        let buildFolder='../../build-release'
    elseif !empty(glob("../../../build"))
        let buildFolder='../../../build'
    elseif !empty(glob("../../../build-debug"))
        let buildFolder='../../../build-debug'
    elseif !empty(glob("../../../build-release"))
        let buildFolder='../../../build-release'
    endif
    if exists("buildFolder")
        let &makeprg= 'make --no-print-directory -C '. (buildFolder)  . (n > 1 ? (' -j'.(n)) : '')
        let b:dispatch= 'env CTEST_OUTPUT_ON_FAILURE=TRUE make test --no-print-directory -C '. (buildFolder)  . (n > 1 ? (' -j'.(n)) : '')
        return
    endif
endfunction
au FileType c,cpp call SetMakeprg()

com! ClearQuickFix call setqflist([])
