set nocompatible
let mapleader=" "

" VIM-PLUG Setup {{{

" Automatic installation {{{
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    au VimEnter * PlugInstall
endif
" }}}

call plug#begin('~/.vim/plugged')
" Debuggers:
" ConqueGdb embeds a gdb terminal in a vim buffer. Best approach ever.
Plug 'vim-scripts/Conque-GDB'
" Conque-GDB Setup {{{
let g:ConqueGdb_Leader='\'
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
" Delete all buffers opened by Conque
nnoremap <silent> <Leader>// :ConqueGdbBDelete
" nnoremap <silent> <Leader>/Y :ConqueGdbCommand y<CR>
" nnoremap <silent> <Leader>/N :ConqueGdbCommand n<CR>
" }}}

Plug 'Shougo/vimproc', { 'do': 'make' } | Plug 'idanarye/vim-vebugger'
" Vebugger Setup {{{
let g:vebugger_leader = '<leader>v'
" }}}

Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'  " Note taking with :Note
" vim-notes Setup {{{
nnoremap <Leader>o :split note:todo<CR>
let g:notes_directories = ['~/Dropbox/VimNotes']
" }}}
Plug 'Raimondi/delimitMate'             " Auto-pair like script
Plug 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plug 'tpope/vim-dispatch'               " Async building. :Make, :Make!, Dispatch for running things.https://github.com/tpope/vim-dispatch
Plug 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
Plug 'tpope/vim-surround'               " cs\"' to change \" for ', or yss) putting the sentence into brackets. The first s is for surround.
Plug 'tpope/vim-obsession'              " Save sessions :Obsess, Restore: vim -S, or :source . Also used by tmux-resurrect
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-sleuth'                 " Automatic detection of indent, based on current file or folder files with same extension.
Plug 'tpope/vim-abolish'                " substitutions with plurals, cases, etc.
Plug 'tpope/vim-repeat'                 " repeat commands(normal mode) with .
Plug 'vim-scripts/visualrepeat'         " works with visual mode too.

Plug 'ntpeters/vim-better-whitespace'   " Highlight whitespaces and provide StripWhiteSpaces()
" Better-whitespace Setup {{{
let g:better_whitespace_filetypes_blacklist=['unite'] " ignore in help files and similar
"}}}
Plug 'drn/zoomwin-vim'
" ZoomWin Setup {{{
nnoremap <leader>z :ZoomWin<cr>
" }}}

" Align and Tabularize:
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/vim-easy-align'
" Easy-Align Setup {{{
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" To align c++ definitions.
augroup Filetype c,c++
    let g:easy_align_delimiters = {
      \ 'd': {
      \     'pattern': ' \ze\S\+\s*[;=]',
      \     'ignore_groups': ['Comment'],
      \     'left_margin': 0,
      \     'right_margin': 0
      \     }
    \}
augroup end
" }}}

Plug 'Yggdroot/indentLine'
" indentLine Setup {{{
let g:indentLine_char = '|'
" let g:indentLine_leadingSpaceChar = '.'
" let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_faster = 1
let g:indentLine_color_term = 239
let g:indentLine_enabled = 1
" }}}

" File Navigation and Search:
Plug 'scrooloose/nerdtree'              " Folder structure viewer
" NerdTREE Setup {{{
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
" }}}

Plug 'kien/ctrlp.vim'                   " Ctrlp to search for / open files
" CtrlP Setup {{{
nnoremap <Leader>t :CtrlPTag<cr>
" }}}

Plug 'rking/ag.vim'                     " Silver searcher integration (similar to ack / grep), search in directory for words. To install silver_searcher: https://github.com/ggreer/the_silver_searcher
Plug 'majutsushi/tagbar'
" Tagbar Setup {{{
nnoremap <silent> <Leader>b :TagbarToggle<CR>
let g:tagbar_sort=0 "Keep order of file.
" }}}

""""""" Color Schemes """""""""""
Plug 'rainux/vim-desert-warm-256'
Plug 'bling/vim-airline'                " Colourful status-line.
" Airline Setup {{{
let g:airline_theme='wombat'
let g:airline#extensions#tabline#enabled = 1 "Show tabs if only one is enabled.
" To show full path: default is %f instead of %F.
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
let g:airline_powerline_fonts = 0
" }}}

"""""""""" TMUX """"""""""""
Plug 'edkolev/tmuxline.vim'             " Status line for tmux (Airline compatible)
Plug 'christoomey/vim-tmux-navigator'   " Navigating vim/tmux with same keys. Default keys are <c-hjkl>
" Tmuxline Setup {{{
let g:tmuxline_powerline_separators = 0
" }}}
" Tmux Navigator tips {{{
" <Ctrl-w b> to go to bottom right window (TagBar). Or <Ctrl-w 2j>
" <Ctrl-w t> to go to top left window.(NERDtree). Or <Ctrl-w 2h>
" TIP: Use <Ctrl-\> to go to last split, specially useful with TabBar.
" }}}

""""" Buffer Related """""
Plug 'vim-scripts/BufOnly.vim'          " :BOnly deltes all buffers except current one.
Plug 'moll/vim-bbye'                    " Bdelete, as Bclose, deleting buffers without deleting windows.
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
nnoremap <Leader>d :Bdelete<CR>
" Close buffer and window (split)
noremap <Leader>q :Bclose<CR><c-W>c

""""" Version Controlling """""
Plug 'airblade/vim-gitgutter'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""" Language Specific Plugins """""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""" LATEX """""""""
Plug 'lervag/vimtex' " Fork from Latex-box. Minimalistic ll to compile, lv to view, xpdf/zathura recommended.
Plug 'vim-auto-save' " To use with Latex files: :AutoSaveToggle
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
Plug 'octol/vim-cpp-enhanced-highlight' " Cpp improved highlight
Plug 'vim-scripts/DoxygenToolkit.vim'

"""""""" R """""""""""""
Plug 'jalvesaq/VimCom'      " Communication vim - R
Plug 'jalvesaq/R-Vim-runtime'
Plug 'jcfaria/Vim-R-plugin' " Too many <Leader> shortcuts???
" R plugins Setup {{{
" install.packages("~/.vim/bundle/VimCom", type = "source", repos = NULL)
" Recommended in R:
" colourout and set with
" download.file("http://www.lepem.ufc.br/jaa/colorout_1.1-0.tar.gz", destfile= "colorout_1.1-0.tar.gz")
" install.packages("colorout_1.1-0.tar.gz", type = "source", repos = NULL)
"  download.file("http://cran.r-project.org/src/contrib/setwidth_1.0-3.tar.gz", destfile= "setwidth_1.0-3.tar.gz")
" install.packages("setwidth_1.0-3.tar.gz", type = "source", repos = NULL)
let vimrplugin_notmuxconf = 1 " To use your own tmux.conf
" let vimrplugin_latexcmd = "~/devtoolset/texlive/2014/bin/x86_64-lqnux/latexmk"
let vimrplugin_assign = "<Leader>_"     " To avoid replacement from _ to <-, to disable = 0
" let vimrplugin_r_path = "~/devtoolset/R/bin"
" }}}
"""""""" Python """"""""""
" Plug 'klen/python-mode'
"""""""" OpenCL """"""""""
Plug 'petRUShka/vim-opencl'
""""""""""CUDA""""""""""""
Plug 'cmaureir/snipmate-snippets-cuda' " snippets and simple syntax.
" Create a symlink inside vim-snippets/snippets pointing to
" snipmate-snippets-cuda/snippets/cu.snippets, and rename it as cuda.snippets.
au BufNewFile,BufRead *.cu  setlocal ft=cuda.cpp
""""""" Rails (Ruby) """":
Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
""""""" Docker """"""
Plug 'ekalinin/Dockerfile.vim'

"""""""AUTOCOMPLETERS"""""
Plug 'SirVer/ultisnips'                 " Awesomeness. Create your own snippets
Plug 'honza/vim-snippets'               " Merged cmake changes!
" UltiSnips Setup {{{
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['UltiSnips',"bundle/vim-snippets/UltiSnips"]
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsListSnippets="<Leader><tab>" "list ,l
" }}}

Plug 'ervandew/supertab'                " Tab to autocomplete.
" Supertab Setup {{{
" TIP: Ctrl-E to return to original without auto-complete
let g:SuperTabDefaultCompletionType = 'context'
set wildmode=list:longest,full
" let g:SuperTabClosePreviewOnPopupClose = 1 " close scratch window on autocompletion
" }}}

let completer = 'oblitum/YouCompleteMe'
Plug completer , { 'do': 'python2 ./install.py --clang-completer --system-libclang' }
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" ctags must be called with --fields=+l (modified in git_templates/ctags)
" BUG in ycm about memory consuption with ctags, put it 0
" meanwhile: https://github.com/Valloric/YouCompleteMe/issues/595

" YouCompleteMe Setup {{{
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_add_preview_to_completeopt = 1
" set completeopt-=preview
" let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
nnoremap <leader>h :YcmCompleter GoToDeclaration<cr>
nnoremap <leader>? :YcmCompleter GoToDefinitionElseDeclaration<cr>
" nnoremap <leader>d :YcmCompleter GoToDefinition<cr>
nnoremap <leader>i :YcmCompleter FixIt<cr>
nnoremap <leader>gt :YcmCompleter GoTo<cr>
nnoremap <leader>gd :YcmCompleter GetDoc<cr>
nnoremap <leader>gy :YcmCompleter GetType<cr>
" }}}

" YCM+UltiSnips+SuperTab {{{
let g:SuperTabDefaultCompletionType = '<C-n>'  " This overrides the default 'Context' for SuperTab+UltiSnips+Eclim
let g:SuperTabCrMapping = 0
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}}

" Multiple-Cursors setup {{{
function! Multiple_cursors_before()
    let g:ycm_auto_trigger = 0
endfunction

function! Multiple_cursors_after()
    let g:ycm_auto_trigger = 1
endfunction
" }}}

Plug 'rhysd/vim-clang-format'
" ClangFormat Setup {{{
let g:clang_format#style_options = {
            \ "AccessModifierOffset": -4,
            \ "AllowShortLoopsOnASingleLine": "false",
            \ "AllowShortBlocksOnASingleLine" : "false",
            \ "AllowShortIfStatementsOnASingleLine": "false",
            \ "AlwaysBreakTemplateDeclarations": "false",
            \ "DerivePointerBinding": "false",
            \ "PointerBindsToType": "false",
            \ "ColumnLimit": 80,
            \ "Standard": "C++11" }
au FileType c,cpp,objc,objcpp noremap  <silent> <buffer> <leader>= :ClangFormat<cr>
" }}}

" Change typedef to using (c++11)
let @t = "^dwf;bde^iusing \<c-R>\" = \e:s/\\s*;/ ;/g\<C-m>"
call plug#end()            " required

" EXPERIMENTAL:
set undofile  " Maintain a undofile to keep changes between sessions.
set undodir=~/.vim/undo/
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
set completeopt=preview,menuone,longest,noselect

set previewheight=12        " increase the default height (12)
set pumheight=30            " limit popup menu height
set concealcursor=nv        " expand concealed characters in insert mode solely

" Open QuickFix horizontally with line wrap
au FileType qf wincmd J | setlocal wrap

" Preview window with line wrap
au BufWinEnter * if &previewwindow | setlocal wrap | resize 7 | endif
" au BufWinEnter * if &previewwindow | setlocal wrap | resize line('$') | endif

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
au BufNewFile,BufRead *.ih setlocal ft=cpp
" Git commits:
autocmd Filetype gitcommit setlocal spell textwidth=72
" Recognize Markdown.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" To use :Man. Read :help man
runtime ftplugin/man.vim
""""""""" General Maps: """""""""""""""""
" Escape remap (avoid Ctrl-C)
inoremap jk <Esc>
" To navigate trough visually wrapped lines.
nnoremap j gj
nnoremap k gk
" To keep the old behavior in gj, gk
nnoremap gj j
nnoremap gk k
" To use with bracketing/indendation with brackets.
imap <c-F> <C-g>g
" inoremap <Leader>k <ESC>kI<TAB>
" inoremap <Leader>h <c-o>h
" Tag Navigation
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
" TimeStamps
nnoremap <leader>f "=strftime("%a %d %b %Y")<CR>P
inoremap <F8> <C-R>=strftime("%a %d %b %Y")<CR>
" " C,C++ specifics:
" use ]f [f from Unimpaired instead
" map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.


" Highlight Cursor
:hi CursorLine cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>cl :set cursorline!<CR>

" Latex-box:
" VimTex Setup {{{
let g:vimtex_latexmk_async=1 " Require gvim --servername vimserver main.tex
let g:vimtex_latexmk_preview_continuosly=1 " -pvc option in latexmk
let g:vimtex_quickfix_ignored_warnings = [
    \ 'Underfull',
    \ 'Overfull',
    \ 'specifier changed to',
  \ ]
let g:vimtex_quickfix_open_on_warning=0
" zathura forwarding require: xdotool
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options_latexmk = '--unique'
" let g:vimtex_latexmk_options="-pdflatex='lualatex -synctex=1 -shell-escape \%O \%S'"
" }}}
syntax spell toplevel
let g:tex_comment_nospell=1
" To save automatically when using <LocalLeader>ll
" autocmd BufNewFile,BufRead *.tex nnoremap <buffer> <LocalLeader>ll :update<CR>:Latexmk<CR>

" Eclim Setup {{{
" installation: http://eclim.org/install.html and
" dotfile: .eclimrc
let g:EclimLogLevel                    = 'debug'
" Options: split, vsplit, edit
let g:EclimDefaultFileOpenAction       = 'edit'
let g:EclimCSearchSingleResult         = 'edit'
let g:EclimBuffersDefaultAction        = 'edit'
let g:EclimLocateFileDefaultAction     = 'edit'
let g:EclimCCallHierarchyDefaultAction = 'edit'
let g:EclimKeepLocalHistory            = 0
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimFileTypeValidate = 0 " Avoid validation on save (memory expensive)
nnoremap <silent> <buffer> <cr> :CSearchContext<cr>
"}}}

"CtrlP and Ag Setup {{{
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif
let g:ctrlp_custom_ignore = '\v[\/](cache|cached)|(\.(swp|ico|git|svn))$'
"}}}

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
" map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
" Vimgreps in the current file
" map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>
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
    elseif !empty(glob("../build-release"))
        let buildFolder='../build-release'
    elseif !empty(glob("../build-debug"))
        let buildFolder='../build-debug'
    elseif !empty(glob("../../build"))
        let buildFolder='../../build'
    elseif !empty(glob("../../build-release"))
        let buildFolder='../../build-release'
    elseif !empty(glob("../../build-debug"))
        let buildFolder='../../build-debug'
    elseif !empty(glob("../../../build"))
        let buildFolder='../../../build'
    elseif !empty(glob("../../../build-release"))
        let buildFolder='../../../build-release'
    elseif !empty(glob("../../../build-debug"))
        let buildFolder='../../../build-debug'
    elseif !empty(glob("../../../../build"))
        let buildFolder='../../../../build'
    elseif !empty(glob("../../../../build-release"))
        let buildFolder='../../../../build-release'
    elseif !empty(glob("../../../../build-debug"))
        let buildFolder='../../../../build-debug'
    endif
    if exists("buildFolder")
        let buildsys="make --stop --no-print-directory"
        if filereadable((buildFolder) . '/rules.ninja')
          let buildsys="ninja"
        endif
        let &makeprg= buildsys . (n > 1 ? (' -j'.(n)) : '')
        let b:dispatch= 'env CTEST_OUTPUT_ON_FAILURE=TRUE make test --no-print-directory' . (n > 1 ? (' -j'.(n)) : '')
    endif
    if exists('b:buildFolder')
        let &makeprg = &makeprg . ' -C ' . (b:buildFolder)
        let b:dispatch = b:dispatch . ' -C ' . (b:buildFolder)
    elseif exists("buildFolder")
        let &makeprg = &makeprg . ' -C ' . (buildFolder)
        let b:dispatch = b:dispatch . ' -C ' . (buildFolder)
        let b:buildFolder = (buildFolder)
    endif
    return

endfunction
au FileType c,cpp call SetMakeprg()

function! BuildAppend(str)
  let b:buildFolder = b:buildFolder . (a:str)
endfunction





com! ClearQuickFix call setqflist([])
