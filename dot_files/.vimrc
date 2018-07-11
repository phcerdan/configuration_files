set nocompatible
" Folding {{{
" set nofoldenable      " disable folding. Slow, even with fastfold plug
" Folding is slow, but useful.
" From wiki: http://vim.wikia.com/wiki/All_folds_open_when_open_a_file
" These options aims to disable it when opening a new buffer.
" Use zM and zR to fold/unfold. zA toggle
set foldlevel=99
set foldlevelstart=99
set foldmethod=syntax
" }}}
let g:loaded_youcompleteme = 1 " YCM slow? Usually no...
syntax on
let mapleader=" "
" For R (and latex?) plugins
let maplocalleader=";"

" Because remap of TAB (== <C-I>) in Supertab, or Ultisnips. ctrl-i does not work as a jumplist-forward
" Note: Now <C-i> works?
" nnoremap <C-s> <C-I>

" Plug manager {{{
" Vim-Plug Automatic installation {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall
endif
" }}}
call plug#begin('~/.vim/plugged')
" Nyaovim Plugs {{{
Plug 'rhysd/nyaovim-markdown-preview'
" }}}
" Debuggers: {{{
" Plug 'phcerdan/minimal_gdb'
" Plug '~/repository_local/minimal_gdb'
Plug 'phcerdan/Conque-GDB' " ConqueGdb embeds a gdb terminal in a vim buffer. Best approach ever. Updated to v0.16.
" let $PYTHONPATH.=":/usr/lib/python2.7/site-packages/lldb"
" Plug 'critiqjo/lldb.nvim'
" " , has('nvim') ? {} : { 'on': [] } " lldb improved (require nvim)
"}}}
" Note-taking utilities Plugins  {{{
  Plug 'Rykka/riv.vim' " reStructuredText (python markdown). I use it as rst syntax/folding rather than note taker.
  " Plug 'vimwiki/vimwiki'  " vim-wiki, natural substitute of org-mode in vim.
  " Plug 'vim-scripts/utl.vim'            " Universal Text Linking (for urls and text linking)
  " Plug 'tpope/vim-speeddating'          " Modify dates with C-A, C-X (like integers)
  " Plug 'mattn/calendar-vim'             " Calendar <localleader>cal
  " Plug 'vim-scripts/SyntaxRange'        " Syntax Highlighting in code blocks
" }}}
" Plug 'metakirby5/codi.vim'              " Interactive scratchpad. Needs real time interpreter. Cling in c++.
" Plug 'Raimondi/delimitMate'             " Auto-pair like script
Plug 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plug 'tpope/vim-rhubarb'                " Gbrowse for github.
Plug 'junegunn/gv.vim'                  " :GV for commit browser, GV! for one this file, GV? fills location list.
Plug 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
" Plug 'tpope/vim-surround'               " cs\"' to change \" for ', or yss) putting the sentence into brackets. The first s is for surround.
Plug 'machakann/vim-sandwich'           " sa{motion/textobject}{addition}
                                        " sd{deletion}
                                        " srb{addition}, sr{deletion}{addition} ie: srb' or sr(' changes (foo) -> 'foo'

Plug 'tpope/vim-obsession'              " Save sessions :Obsess, Restore: vim -S, or :source . Also used by tmux-resurrect
Plug 'tomtom/tcomment_vim'              " Toggle comment with gcc
Plug 'tpope/vim-sleuth'                 " Automatic detection of indent, based on current file or folder files with same extension.
Plug 'tpope/vim-abolish'                " substitutions with plurals, cases, etc.
Plug 'tpope/vim-repeat'                 " repeat commands(normal mode) with .
Plug 'vim-scripts/visualrepeat'         " works with visual mode too.
" Plug 'tpope/vim-dispatch'             " Using asyncrun instead. Async building. :Make, :Make!, Dispatch for running things.https://github.com/tpope/vim-dispatch
Plug 'tpope/vim-eunuch' " Adds helpers for UNIX shell commands
                        " :Remove Delete buffer and file at same time
                        " :Unlink Delete file, keep buffer
                        " :Move Rename buffer and file
" Plug 'radenling/vim-dispatch-neovim'    " STILL TOO EXPERIMENTAL Add support to running in a nvim :terminal
Plug 'skywind3000/asyncrun.vim'         " async :! command, read output using error format, or use % raw to ignore.
Plug 'mh21/errormarker.vim'             " errormarker to display errors of asyncrun , https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
" Plug 'w0rp/ale'                         " Linting real-time
Plug 'phcerdan/ale'                       " my fork with header linting hack (providing .cpp per header)
" Plug '~/repository_local/vim-dev/ale'                         " Linting real-time
" Plug 'benekastah/neomake', has('nvim') ? {} : { 'on': [] } " Async building for neovim. :Make, :Make! GOLD
Plug 'vim-scripts/restore_view.vim'     " Restore file position and FOLDS.
" Plug 'vim-scripts/delview'              " Delete stored view with :delview.
Plug 'yssl/QFEnter'                       " Open items from qf/loc lists in whatever buffer
" Plug 'milkypostman/vim-togglelist'      " Default mapping to <Leader>q, <Leader>l GOLD
" Plug 'Valloric/ListToggle'              " Default mapping to <Leader>q, <Leader>l
" Plug 'romainl/vim-qf'
" vim-qf Setup {{{
" Doesn't play well with asyncrun, vimtex, etc, with auto_open.
"  let g:qf_auto_open_quickfix = 0
"  let g:qf_auto_open_loclist = 0
"  nmap <Leader>q <Plug>qf_qf_stay_toggle
"  nmap <Leader>l <Plug>qf_loc_stay_toggle
" quickfix/loc list toggle from vim wiki {{{
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
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
" }}}
" }}}
Plug 'simnalamburt/vim-mundo'           " Navigate undo history.
nnoremap <F5> :MundoToggle<CR>
Plug 'ntpeters/vim-better-whitespace'   " Highlight whitespaces and provide StripWhiteSpaces()
" Plug 'troydm/zoomwintab.vim'             " Does not work well in neovim.
" Align and Tabularize: {{{
" Plug 'terryma/vim-multiple-cursors'     " <C-n> to select next word for multiple modification. Sublime style. Not used. Colliding default keys.
Plug 'junegunn/vim-easy-align'
" Plug 'junegunn/vim-peekaboo'              " Expand when using registers (Pretty optional)
Plug 'Yggdroot/indentLine'
" }}}
" File Navigation and Search: {{{
" Plug 'francoiscabrol/ranger.vim'        " Ranger example converted to a plugin. :Ranger
" Plug 'justinmk/vim-dirvish'             " Minimalist file-explorer, aims to replace vim-built-in netwr.
"      Incompatible with autochdir option: https://github.com/justinmk/vim-dirvish/issues/19
Plug 'scrooloose/nerdtree'              " Folder structure viewer
Plug 'Xuyuanp/nerdtree-git-plugin'
" }}}
" Search/Grep {{{
Plug 'mhinz/vim-grepper' " Modular approach. Default is ag.
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim', has('fzf') ? {} : { 'off': [] } " Ctrlp to search for / open files. Worse than zfz.
Plug 'junegunn/fzf', { 'do': './install --all' } " Command line (zsh, etc) fuzzy searcher. Better than CtrlP (only unix)
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
" }}}
"Color Schemes and status-line {{{
Plug 'rainux/vim-desert-warm-256'
" Plug 'justinmk/molokai'
" Include inversion of fg/bg in MatchParen (PR opened upstream)
Plug 'phcerdan/molokai'
" Plug 'joshdick/onedark.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'chriskempson/base16-vim'
" Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'     " Colourful status-line.
Plug 'vim-airline/vim-airline-themes'
Plug 'gcmt/taboo.vim'              " Rename tabs
Plug 'ryanoasis/vim-devicons'      " powerline icons in vim.
Plug 'drzel/vim-line-no-indicator' " Save character in status line to report relative position in file.
"}}}
" TMUX {{{
" Plug 'edkolev/tmuxline.vim'             " Status line for tmux (Airline compatible)
Plug 'christoomey/vim-tmux-navigator'   " Navigating vim/tmux with same keys. Default keys are <c-hjkl>
Plug 'jpalardy/vim-slime'               " Slime (emacs). Send/Copy from vim to other pane
Plug 'benmills/vimux'                   " Call tmux from vim (used for calling emacs org-mode)
" }}}
" Buffer Related {{{
" Switch to latest used buffer
Plug 'vim-scripts/BufOnly.vim'          " :BOnly deltes all buffers except current one.
Plug 'moll/vim-bbye'                    " Bdelete, as Bclose, deleting buffers without deleting windows.
Plug 'phcerdan/a.vim'                   " :A to switch between h, c files. Fork to switch between h and hxx (ITK)
"}}}
" Diff tools {{{
Plug 'AndrewRadev/linediff.vim' " :Linediff in v-selection (x2) will compare chunks
" }}}
" Version Controlling {{{
Plug 'airblade/vim-gitgutter'
"}}}
" Style / Grammar check {{{
Plug 'sbdchd/neoformat'
Plug 'rhysd/vim-clang-format'
Plug 'rhysd/vim-grammarous'
" }}}
" Docs navigation {{{
" Also see Cppman for c++
Plug 'KabbAmine/zeavim.vim'
" }}}
" Tools/Utilities {{{
Plug 'qpkorr/vim-renamer'
" }}}
" Language Clients {{{
" vim-lsp {{{
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_async_completion = 1
" au FileType c,c++ setlocal omnifunc=lsp#complete
" au FileType python setlocal omnifunc=lsp#complete

autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fh :LspHover<cr>
autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fd :LspDefinition<cr>
autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fr :LspReferences<cr>
autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fn :LspDocumentFormat<cr>
autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fi :LspImplementation<cr>
autocmd FileType python,c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <F3> :LspRename<cr>
" }}}
" vim-lsp-cquery{{{
autocmd FileType c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fv :LspCqueryDerived<CR>
autocmd FileType c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fc :LspCqueryCallers<CR>
autocmd FileType c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fb :LspCqueryBase<CR>
autocmd FileType c,cc,cpp,cxx,h,hh,hpp,hxx nnoremap <leader>fi :LspCqueryVars<CR>
if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/home/phc/tmp/cquery_cache' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif
" }}}
" python-language-server {{{
if (executable('pyls'))
    au User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'whitelist': ['python']
    \ })
endif
" }}}
" }}} Language Client
" Language Specific Plugins and Settings {{{
" LATEX {{{
Plug 'lervag/vimtex' " Fork from Latex-box. Minimalistic ll to compile, lv to view, xpdf/zathura recommended.
Plug 'brennier/quicktex' " Shortcuts/Abbreviations for latex
"}}}
" R {{{
" Plug 'jalvesaq/R-Vim-runtime' " Included in vim,nvim binaries. But just in case...
" Plug 'jalvesaq/VimCom'      " Communication vim - R
" Plug 'jcfaria/Vim-R-plugin' " Too many <Leader> shortcuts???
Plug 'jalvesaq/Nvim-R' " Includes VimCom functionalities.
" }}}
" Python {{{
" Plug 'klen/python-mode', { 'branch': 'develop'} " python-mode is just too heavy, you don't really need rope.
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fs111/pydoc.vim'
" Plug 'nvie/vim-flake8'
" , has('flake8') ? {} : { 'on': [] } " lint for python. Require flake8 installation
" }}}
" OpenCL {{{
Plug 'petRUShka/vim-opencl'
"}}}
"CUDA {{{
" Create a symlink inside vim-snippets/snippets pointing to
" snipmate-snippets-cuda/snippets/cu.snippets, and rename it as cuda.snippets.
Plug 'cmaureir/snipmate-snippets-cuda' " snippets and simple syntax.
"}}}
" HTML {{{
Plug 'mattn/emmet-vim'
" }}}
" Rails (Ruby) {{{
" Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
" }}}
"Docker {{{
Plug 'ekalinin/Dockerfile.vim'
" }}}
" Markdown / vimwiki {{{
Plug 'phcerdan/vim-flavored-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'
"}}}
" CMake {{{
" Plug 'pboettch/vim-cmake-syntax'
" Add one commit with ITK-specific functions
Plug 'phcerdan/vim-cmake-syntax'
" }}}
" C++ {{{
Plug 'octol/vim-cpp-enhanced-highlight' " Cpp improved highlight
Plug 'vim-scripts/DoxygenToolkit.vim'
" }}}
"End of Language specifics }}}
" AUTOCOMPLETERS {{{
Plug 'SirVer/ultisnips'                 " Awesomeness. Create your own snippets
Plug 'honza/vim-snippets'               " Merged cmake changes!
" Plug 'ervandew/supertab'                " Tab to autocomplete.
" javascript {{{
" Not needed if ycm has --tern-completer
" Plug 'ternjs/tern_for_vim'
" }}}
" YCM {{{
" let completer = 'oblitum/YouCompleteMe'
let completer = 'Valloric/YouCompleteMe'
" In ARCH libtinfo is missing. Install with cower -d ncurses5-compat-libs
" More info in issue: https://github.com/Valloric/YouCompleteMe/issues/778
" Plug completer , { 'do': 'python2 ./install.py' }
" Plug completer , { 'do': 'cd ./third_party/ycmd ; patch -p1 < ~/repository_local/configuration_files/vim/cpp_trigger_patch.txt ; cd ../../ ; python2 ./install.py' }
" Plug completer , { 'do': 'python ./install.py --clang-completer' }
" Apply patch to allow c++ completion with templates (slower)
" Plug completer , { 'do': ' cd ./third_party/ycmd ; git apply ~/repository_local/configuration_files/vim/patch_cpp_incomplete.diff ; cd ../../ ; python2 ./install.py --clang-completer' }
" Plug completer , { 'do': 'python2 ./install.py --clang-completer --system-libclang' }
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" ctags must be called with --fields=+l (modified in git_templates/ctags)
" BUG in ycm about memory consuption with ctags, put it 0
" meanwhile: https://github.com/Valloric/YouCompleteMe/issues/595
" }}}
" Plug 'davidhalter/jedi-vim'
" Plug 'tenfyzhong/CompleteParameter.vim'
" }}} End autocompleters
" Plug 'lyuts/vim-rtags'                  " Require rtags server: rc
" Language Client {{
" LanguageClient-Neovim {{{
" if has('nvim')
"   " To install run in shell: nvim +PlugInstall +UpdateRemotePlugins +qa
"   Plug 'autozimu/LanguageClient-neovim', {
"         \ 'branch': 'next',
"         \ 'do': 'bash install.sh',
"         \ }
"    " This will make LanguageClient pause 0.5 second to send text changes to server
"    " after one textDocument_didChange is sent.
"   let g:LanguageClient_changeThrottle = 0.5
"   " For clangd:
"   let g:LanguageClient_serverCommands = {
"         \ 'cpp': ['clangd'],
"         \ }
"   " see: clangd --help for options,
"   " or directly: https://github.com/llvm-mirror/clang-tools-extra/blob/master/clangd/tool/ClangdMain.cpp
"   " \ 'cpp': ['clangd']
"   " \ 'python': ['pyls'],
"
"   " For cquery: https://github.com/cquery-project/cquery/wiki/Neovim
"   " let g:LanguageClient_serverCommands = {
"   "       \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
"   "       \ }
"   let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
"   let g:LanguageClient_settingsPath = expand('~/.config/nvim/settings.json')
"   nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
"   nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
"   nnoremap <silent> grn :call LanguageClient_textDocument_rename()<CR>
"   nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
"   " List of current buffer's symbols.
"   nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
"   nnoremap <silent> ge :call LanguageClient_textDocument_signatureHelp()<CR>
"   vnoremap <silent> gf :call LanguageClient_textDocument_rangeFormatting()<CR>
" endif
" }}} LanguageClient-neovim
" vim-lsp {{{
" First install vim-lsp, this plugin relies on it:
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'pdavydov108/vim-lsp-cquery'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
let g:asyncomplete_remove_duplicates = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
  " Plug 'zchee/deoplete-jedi'
" Showing function signature and inline doc.
" The entry needs to be selected with <C-y> for the doc to echo.
" Plug 'Shougo/echodoc.vim'
" let g:echodoc#enable_at_startup = 1
" Use deoplete.
let g:deoplete#enable_at_startup = 0
let g:deoplete#disable_auto_complete = 1
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#disable_auto_complete = 0
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ deoplete#mappings#manual_complete()


" External sources:
let g:deoplete#sources = {}
let g:deoplete#sources._ = ['ultisnips']
" Extra deoplete sources {{{
" Plug 'tweekmonster/deoplete-clang2'
" Plug 'zchee/deoplete-clang'
" let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
" let g:deoplete#sources#clang#clang_header='/usr/lib/clang'
" let g:deoplete#sources.cpp = ['buffer', 'clang']
" }}}
" vim-rtags Setup {{{
  let g:rtagsUseLocationList = 0
" }}}
" web {{{

" if has('nvim')
"   Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
"   Plug 'vyzyv/vimpyter'
" endif
" }}}
call plug#end()            " required
" vim-plug END }}}
" vim-sandwich Setup {{{
  let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
  "From wiki: https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
  " Textobjects to select the nearest surrounded text automatically:
    xmap iss <Plug>(textobj-sandwich-auto-i)
    xmap ass <Plug>(textobj-sandwich-auto-a)
    omap iss <Plug>(textobj-sandwich-auto-i)
    omap ass <Plug>(textobj-sandwich-auto-a)

  " Textobjects to select a text surrounded by same characters user input.
    xmap im <Plug>(textobj-sandwich-literal-query-i)
    xmap am <Plug>(textobj-sandwich-literal-query-a)
    omap im <Plug>(textobj-sandwich-literal-query-i)
    omap am <Plug>(textobj-sandwich-literal-query-a)

" }}}

" nyaovim Setup {{{
  let g:markdown_preview_auto =1
" }}}
"
" Debuggers Setup {{{
" Conque-GDB Setup {{{
" Set localsyntax of ConqueGDB buffer to cpp
  let g:ConqueTerm_Syntax = 'cpp'
  let g:ConqueGdb_Leader='\'
  let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
  let g:ConqueTerm_CloseOnEnd = 0    " close conque when program ends running
  let g:ConqueTerm_StartMessages = 1 " display warning messages if conqueTerm is configured incorrectly
" let g:ConqueGdb_SrcSplit = 'right' " Split the source code 'xxx' of GDB window.
" Delete all buffers opened by Conque
" nnoremap <silent> <Leader>// :ConqueGdbBDelete<CR>
" nnoremap <silent> <Leader>/Y :ConqueGdbCommand y<CR>
" nnoremap <silent> <Leader>/N :ConqueGdbCommand n<CR>
" }}}
"
" lldb Setup {{{
" nmap <Leader>db <Plug>LLBreakSwitch
" nnoremap <Leader>dd :LLmode debug<CR>
" nnoremap <Leader>dD :LLmode code<CR>
" nnoremap <Leader>dc :LL continue<CR>
" nnoremap <Leader>dn :LL next<CR>
" nnoremap <Leader>dni :LL thread step-over-inst<CR>
" nnoremap <Leader>ds :LL step<CR>
" nnoremap <Leader>dsi :LL thread step-inst<CR>
" nnoremap <Leader>df :LL finish<CR>
" nnoremap <Leader>dI :LL process interrupt<CR>
" nnoremap <Leader>dK :LL process kill<CR>
" nnoremap <Leader>dp :LL print <C-R>=expand('<cword>')<CR>
" vnoremap <Leader>dp :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>
" nnoremap <Leader>dle :LLsession bp-set<CR>
" nnoremap <Leader>dlw :LLsession bp-save<CR>
" nnoremap <Leader>dlr :LLsession reload<CR>
" nnoremap <Leader>dll :LLsession load
" " }}}
" Debuggers End }}}

" Organization/Note taking
" vimwiki Setup {{{
  " let g:vimwiki_conceallevel = 0
  " let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki',
  "                       \ 'syntax': 'markdown', 'ext': '.md',
  "                       \ 'nested_syntaxes': {'cpp': 'cpp'}}]
  " function! VimwikiLinkHandler(link)
  "   " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
  "   "   1) [[vfile:~/Code/PythonProject/abc123.py]]
  "   "   2) [[vfile:./|Wiki Home]]
  "   let link = a:link
  "   if link =~# '^vfile:'
  "     let link = link[1:]
  "   else
  "     return 0
  "   endif
  "   let link_infos = vimwiki#base#resolve_link(link)
  "   if link_infos.filename == ''
  "     echomsg 'Vimwiki Error: Unable to resolve link!'
  "     return 0
  "   else
  "     exe 'tabnew ' . fnameescape(link_infos.filename)
  "     return 1
  "   endif
  " endfunction
" }}}

" Fugitive and vim-rhubarb Setup {{{
  nnoremap <Leader>gs :Gstatus<CR>
  let g:fugitive_git_executable = 'hub'
" }}}

" restore_view Setup{{{
  set viewoptions=cursor,folds,slash,unix
" }}}

" ZoomWinTab Setup {{{
" Default: <C-w>o
  map <Leader>zzz :ZoomWinTabToggle<CR>
" }}}

" Easy-Align Setup {{{
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
  " To align c++ definitions.
  augroup FileType c,c++
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

" indentLine Setup {{{
  let g:indentLine_char = '|'
  " let g:indentLine_leadingSpaceChar = '.'
  " let g:indentLine_leadingSpaceEnabled = 1
  let g:indentLine_faster = 1
  let g:indentLine_color_term = 239
  let g:indentLine_enabled = 1
" }}}

" NerdTREE Setup {{{
  nnoremap <silent> <Leader>nn :NERDTreeFind<CR>
" }}}

" Ack/Ag Setup {{{
  if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
    " cnoreabbrev Ag Ack
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
    nnoremap <silent> <Leader>/ :execute 'Ack ' . input('Ack/')<CR>
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  endif
"}}}

"CtrlP Setup{{{
  if executable('ag')
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      " ag is fast enough that CtrlP doesn't need to cache
      let g:ctrlp_use_caching = 0
      let g:ctrlp_map=''
  endif
  " nnoremap <Leader>t :CtrlPTag<cr>
  let g:ctrlp_custom_ignore = '\v[\/](cache|cached)|(\.(swp|ico|git|svn))$'
  let g:ctrlp_max_files=0
  let g:ctrlp_max_depth=40
"}}}

" fzf Setup {{{
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
let g:fzf_command_prefix = 'F'
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
" let g:fzf_history_dir = '~/.fzf-history'

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <C-x><C-j> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)

fun! s:fzf_root()
  let path = finddir(".git", expand("%:p:h").";")
  return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
command! -nargs=* GAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), g:fzf_layout))
" Use rg (ripgrep, Faster!)
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
command! -nargs=* GAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), g:fzf_layout))
" Specialized for ITK.
let g:ITKFolder = '~/Software/ITK/ITK-development'
function! s:with_itk_git_root()
  let root = systemlist('git -C '. g:ITKFolder . ' rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
command! -nargs=* IAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_itk_git_root(), g:fzf_layout))
command! -nargs=* IFiles
  \ call fzf#vim#files(<q-args>, extend(s:with_itk_git_root(), g:fzf_layout))
" Map C-p to override CtrlP plugin.
nnoremap <silent> <C-p> :exe 'FFiles ' . <SID>fzf_root()<CR>
nnoremap <silent> <Leader>b :FBuffers<CR>
nnoremap <silent> <Leader>bB :FWindows<CR>
nnoremap <silent> <Leader>; :FCommands<CR>
nnoremap <silent> <Leader>fhl :FHelptags<CR>
nnoremap <silent> <Leader>fl :FLines<CR>
nnoremap <silent> <Leader>fL :FBLines<CR>
nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <Leader>ft :FTags<CR>
nnoremap <silent> <Leader>fT :FBTags<CR>
nnoremap <silent> <Leader>gl :FCommits<CR>
nnoremap <silent> <Leader>ga :FBCommits<CR>

command! -bang -nargs=* PAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)


" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir PFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


function! SearchWordWithAg()
  let ag_command = 'Ack!'
  execute ag_command expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let ag_command = 'Ag!'
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute ag_command selection
endfunction
" }}}

" Tagbar Setup {{{
  nnoremap <silent> <Leader>bb :TagbarToggle<CR>
  let g:tagbar_sort=0 "Keep order of file.
" }}}

" Jellybeans setup{{{
  let g:jellybeans_use_term_italics = 1
  " let g:jellybeans_use_lowcolor_black = 0
" }}}
" Onedark setup{{{
  " let g:onedark_terminal_italics = 1
" }}}

" lightline setup {{{
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ }
" }}}

" Airline Setup {{{
  let g:airline_theme='wombat'
  let g:airline#extensions#tabline#enabled = 1 "Show tabs if only one is enabled.
  let g:airline#extensions#tabline#show_splits = 1 "enable/disable displaying open splits per tab (only when tabs are opened). >
  let g:airline#extensions#tabline#show_buffers = 1 " enable/disable displaying buffers with a single tab
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 1

  let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
  let g:line_no_indicator_chars = ['⎺', '⎻', '─', '⎼', '⎽']
  " let g:airline_section_y = '%{LineNoIndicator()}'
  let g:airline_section_z = '%{LineNoIndicator()}'
  " Slow integrations disabled:
  let g:airline#extensions#wordcount#enabled = 0
  let g:airline#extensions#tagbar#enabled = 0
  let g:airline#extensions#ycm#enabled = 0
  " if exists("g:loaded_line_no_indicator")
  " endif
  " To show full path: default is %f instead of %F.
  " let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
  " ale
  let g:airline#extensions#ale#enabled = 1
  " integration:{{{
  " let g:airline#extensions#neomake#enabled = 1
  " let g:airline#extensions#eclim#enabled = 0
  " fzf slow on close: https://github.com/neovim/neovim/issues/4487
  let g:airline#extensions#branch#enabled = 0
  " asyncrun status:
  let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
  "}}}
  let g:airline_powerline_fonts = 1
" }}}

" vim-devicons Options {{{
  let g:WebDevIconsOS="Linux"
  " set guifont=Droid\ Sans\ Mono\ Awesome\ Regular\ 11
" }}}
" Taboo Options {{{ :TabooRename, TabooOpen aname
" To restore tab names.
 " let g:airline#extensions#taboo#enabled = 0
 " let g:loaded_taboo = 1
 let g:taboo_tabline=0
 set sessionoptions+=tabpages,globals
" }}}

" vim-slime Setup {{{
  let g:slime_target = "tmux"
  let g:slime_python_ipython = 1
  " :SlimeConfig socket name is usually default.
  " send to: :5.2 <- Window 5, second pane. or :5.%45, if you know the PaneId
  " from echo $TMUX_PANE
  command! TmuxSockets silent! !lsof -U | grep "^tmux"
" }}}

" Vimux Setup {{{
  let g:VimuxHeight = "25" " Default is 20
  let g:VimuxUseNearest = 1  " With 0 always split, with 1 attach if pane exist
  map <Leader>xc :VimuxCloseRunner<CR>
  map <Leader>xx :VimuxRunLastCommand<CR>
  " Calling Emacs from vim for org-mode
  " org is an alias (in .aliases) similar or equal to:'emacs -nw ~/path/to/organizer.org'

  function! VimuxSwitchOrRun(command)
    if exists("g:VimuxRunnerIndex")
      call _VimuxTmux("select-"._VimuxRunnerType()." -t ".g:VimuxRunnerIndex)
    else
      call VimuxRunCommand(a:command)
    endif
  endfunction
  fun! VimuxCloseOrgMode()
    " Save all buffers, and quit.
    :call VimuxSendKeys(":xa")
    :call VimuxCloseRunner()
  endfunction
  nnoremap <Leader>vy :call VimuxSwitchOrRun("orgclient")<CR>
  nnoremap <Leader>vY :call VimuxCloseOrgMode()<CR>
" }}}

" Tmuxline Setup {{{
  let g:tmuxline_powerline_separators = 0
  " Tmux Navigator tips {{{
  " <Ctrl-w b> to go to bottom right window (TagBar). Or <Ctrl-w 2j>
  " <Ctrl-w t> to go to top left window.(NERDtree). Or <Ctrl-w 2h>
  " TIP: Use <Ctrl-\> to go to last split, specially useful with TabBar.
  " }}}
" }}}

" vim-bbye Setup {{{
  nnoremap <Leader>h :b#<CR>
  command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
  nnoremap <Leader>d :Bdelete<CR>
  " Close buffer and window (split)
  " noremap <Leader>q :Bclose<CR><c-W>c
"}}}

" Gitgutter Setup {{{
" let g:loaded_gitgutter=1 " Slow, don't load it.
" }}}
"
" git commit {{{
autocmd FileType gitcommit setlocal spell
" }}}

" vim-clang-format Setup {{{
let g:clang_format#detect_style_file=1 " Auto detect .clang-format file.
" When the value is 1, formatexpr option is set by vim-clang-format
" automatically in C, C++ and ObjC codes.
" Vim's format mappings (e.g. gq) get to use clang-format to format.
" This option is not comptabile with Vim's textwidth feature.
" You must set textwidth to 0 when the formatexpr is set.
let g:clang_format#auto_formatexpr=1
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>ff :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>ff :ClangFormat<CR>
" }}}
" neoformat Setup {{{
inoremap <Leader>nf :Neoformat

" C++ {{{
" let g:neoformat_cpp_clangformat = {
"       \ 'exe': 'clang-format',
"       \ 'args': ['-style="{IndentWidth: 4,TabWidth: 4 }"'],
"       \ 'stdin': 1,
"       \ }
" " itk {{{
" let g:neoformat_cpp_itk = {
"       \ 'exe': 'uncrustify',
"       \ 'args': ['-c ' . expand(g:ITKFolder) . '/Utilities/Maintenance/uncrustify_itk_aggressive.cfg', '-q', '-l CPP', '--frag'],
"       \ 'stdin': 1,
"       \ }
" " }}}
" let g:neoformat_enabled_cpp = ['itk', 'uncrustify', 'clangformat', 'astyle']
"}}}

" Python {{{
" need to install yapf/autopep in system.
let g:neoformat_enabled_python = ['autopep8']
" }}}
" }}}
" vim-grammarous Setup {{{
  let g:grammarous#disabled_rules = {
        \ 'tex' : ['WHITESPACE_RULE', 'EN_QUOTES', 'COMMA_PARENTHESIS_WHITESPACE', 'CURRENCY', 'EN_UNPAIRED_BRACKETS'],
        \ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
        \ }
  let g:grammarous#show_first_error = 1
  nmap <localleader>. <Plug>(grammarous-open-info-window)
" }}}
" LaTeX Setup {{{
".tex FILE IS ALWAYS LATEX
let g:tex_flavor = 'tex'
let g:tex_comment_nospell=1
let g:tex_conceal = ""
" au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak breakindent showbreak=..
au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak showbreak=..
" quicktex Setup {{{
" From: https://github.com/brennier/quicktex#configuration
" Use default dictionaries from plugin.
" }}}

" VimTex Setup {{{
" let g:vimtex_quickfix_mode = 0
  if has('nvim')
    " Neovim support: https://github.com/lervag/vimtex/issues/262 NOT READY
    " Instead of nvim use: gvim -v --servername vimserver
    " (aliased to viserver)
    let g:vimtex_compiler_progname = 'nvr'
  endif
  " Workaround for buggy behaviour where quicktex thinks we are in math mode.
  function QuickTexDisableMathMode()
    let g:quicktex_math=g:quicktex_tex
  endfunction
  command! QuickTexDisableMathMode call QuickTexDisableMathMode()

  set thesaurus+=~/.vim/thesaurus_moby.txt
  let g:vimtex_fold_enabled=0 " Need to use fastFold with this option or... really slow.
  let g:vimtex_fold_manual=1 " autofold is slow in vim, use FastFold instead of this option!.
  let g:vimtex_compiler_latexmk = {
        \ 'continuous' : 1,
        \}
  let g:vimtex_quickfix_latexlog = {
        \ 'overfull' : 0,
        \ 'underfull' : 0,
        \ }
  let g:vimtex_quickfix_autojump=0
  let g:vimtex_quickfix_open_on_warning=0
  " zathura forwarding require: xdotool but xdotool fails in arch (wayland?)
  " let g:vimtex_view_method = 'zathura'
  " let g:vimtex_view_general_viewer = 'mupdf'
  " For Okular {{{
  let g:vimtex_view_general_viewer = 'okular'
  " Forward:
  let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
  " Backward search:
    " (Shift + LeftClick) in Browse mode:
    " Configure Okular first: Settings, Okular Config, Editor:
    " Open file with 'nviserver file.tex' (alias of:
    " NVIM_LISTEN_ADDRESS=/tmp/nvimserver nvim
    " nvr --servername=/tmp/nvimserver --remote-silent %f -c %l
  " }}}
  " let g:vimtex_latexmk_options='-file-line-error -verbose -pdf -interaction="nonstopmode" -pdflatex="lualatex -synctex=1 -shell-escape \%O \%S"'
  " This line works for beamer
  " let g:vimtex_latexmk_options='-pdf -verbose -file-line-error -pdflatex="lualatex -shell-escape -synctex=1 -interaction=nonstopmode \%O \%S"'
  " With YCM completion
  if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
  endif
  let g:ycm_semantic_triggers.tex = [
        \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
        \ 're!\\hyperref\[[^]]*',
        \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\(include(only)?|input){[^}]*',
        \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
        \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
        \ ]
" To save automatically when using <LocalLeader>ll
" autocmd BufNewFile,BufRead *.tex nnoremap <buffer> <LocalLeader>ll :update<CR>:Latexmk<CR>
" }}}
" Plug 'vim-auto-save' " To use with Latex files: :AutoSaveToggle
"   let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
Plug 'Konfekt/FastFold' " auto fold is slow
" FastFold Setup {{{
  let g:fastfold_savehook = 0 " Only update manually with keys: zuz, or when :FastFoldUpdate
  let g:tex_fold_enabled = 1
  let g:vimsyn_folding='af'
  " let g:cpp_folding = 1
  " let g:vim_folding = 1
  " let g:python_folding = 1
" }}}
" }}}
" Docs navigation {{{
" zeavim {{{
nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap gz <Plug>ZVMotion
nmap <leader><leader>z <Plug>ZVKeyDocset
let g:zv_file_types = {
      \ 'help'               : 'vim',
      \ 'djangohtml'         : 'django, html',
      \ }
let g:zv_zeal_args = has('unix') ? '--style=gtk+' : ''
" }}}
" }}}

" Nvim-R plugins Setup {{{
  " install.packages("~/.vim/bundle/VimCom", type = "source", repos = NULL)
  " Recommended in R:
  " colourout and set with
  " download.file("http://www.lepem.ufc.br/jaa/colorout_1.1-0.tar.gz", destfile= "colorout_1.1-0.tar.gz")
  " install.packages("colorout_1.1-0.tar.gz", type = "source", repos = NULL)
  "  download.file("http://cran.r-project.org/src/contrib/setwidth_1.0-3.tar.gz", destfile= "setwidth_1.0-3.tar.gz")
  " install.packages("setwidth_1.0-3.tar.gz", type = "source", repos = NULL)
  let R_notmuxconf = 1 " To use your own tmux.conf
  " let vimrplugin_latexcmd = "~/devtoolset/texlive/2014/bin/x86_64-lqnux/latexmk"
  let R_assign = "<LocalLeader>_"     " To avoid replacement from _ to <-, to disable = 0
  " To lunch in split tmux. It needs in .tmux.conf to export R_LIBS
  " set -g update-environment "R_LIBS_USER R_LIBS"
  let R_rconsole_width = 80
  let R_objbr_place = "script,left"

  if !has('nvim')
    " if tmux preffered (or vim)
    let R_in_buffer = 0
    let R_applescript = 0
    let R_tmux_split = 1
  endif

  " let vimrplugin_r_path = "~/devtoolset/R/bin"
  " if has("gui_running")
  "     inoremap <C-Space> <C-x><C-o>
  " else
  "     inoremap <Nul> <C-x><C-o>
  " endif
  vmap <Space> <Plug>RDSendSelection
  nmap <Space> <Plug>RDSendLine
" }}}

" Python Setup {{{
  autocmd FileType python set sw=4
  autocmd FileType python set ts=4
  autocmd FileType python set sts=4
  if has('nvim')
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
  endif
" To run current file.
au FileType python nnoremap <buffer> <Leader>e :exec '!python' shellescape(@%, 1)<cr>
" python-mode Setup {{{
  " let g:pymode_rope_completion = 0 " Use YCM instead
" }}}
" vim-flake8 Setup {{{
" Default mapping is <F7>
  let g:flake8_show_in_gutter=1
  let g:flake8_show_in_file=1
  " let no_flake8_maps = 1
" }}}
" SLOW:
" Plug 'jmcantrell/vim-virtualenv'
" vim-virtualenv Setup {{{
  " let g:virtualenv_directory='/home/phc/repository_local'
" }}}
" }}}

" CUDA Setup {{{
au BufNewFile,BufRead *.cu  setlocal ft=cuda.cpp
" }}}

" Git Setup {{{
autocmd Filetype gitcommit setlocal spell textwidth=72
"}}}

" Markdown Setup {{{
" vim-markdown-preview {{{
let vim_markdown_preview_toggle=0
let vim_markdown_preview_hotkey='<Leader>v'
" let vim_markdown_preview_browser='firefox'
" let vim_markdown_preview_browser='google-chrome-stable'
let vim_markdown_preview_use_xdg_open=1
" Requires python-grip and network (query gh servers)
let vim_markdown_preview_github=1
" }}}
autocmd BufNewFile,BufReadPost *.md,*.markdown set filetype=ghmarkdown.markdown
" au FileType markdown setlocal conceallevel=0
" }}}

" XML Setup {{{
augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml :syntax on
    autocmd FileType xml normal zR
augroup END
" }}}

" C++ Setup {{{
" From :h ft-c-syntax. Avoid folding comments
let c_no_comment_fold = 1
" DoxygenToolkit Setup {{{
  let g:DoxygenToolkit_briefTag_pre = '' " Remove @brief tag. (First line will be parsed as brief anyway).
" }}}
" Map to reformat 'typedef' to 'using' (c++11)
let @t = "^dwf;bde^iusing \<c-R>\" = \e:s/\\s*;/;/g\<C-m>"
" let @o = '^cf auto '
let @o = "/Pointer\<C-m>whc^auto"
" :g/::Pointer\s[0-9a-zA-Z]*\s\?=/norm! @o
" set ft in files: {{{
au BufNewFile,BufRead *.txx setlocal ft=cpp
au BufNewFile,BufRead *.ih setlocal ft=cpp
"}}}
" Switch header-implementation {{{
" use ]f [f from Unimpaired instead
" map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.
" }}}
" Cppman in tmux pane {{{
command! -nargs=+ Cppman silent! call system("tmux split-window cppman " . expand(<q-args>))
autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>
"}}}
au FileType c,cpp au BufReadPre,BufNewFile itk execute IndentITK
" Eclim Setup {{{
" installation: http://eclim.org/install.html and
" dotfile: .eclimrc
  "" let g:EclimLogLevel                    = 'debug'
  "" Options: split, vsplit, edit
  " let g:EclimDefaultFileOpenAction       = 'edit'
  " let g:EclimCSearchSingleResult         = 'edit'
  " let g:EclimBuffersDefaultAction        = 'edit'
  " let g:EclimLocateFileDefaultAction     = 'edit'
  " let g:EclimCCallHierarchyDefaultAction = 'edit'
  " let g:EclimKeepLocalHistory            = 0
  " let g:EclimFileTypeValidate = 0 " Avoid validation on save (memory expensive)
  " au FileType c,cpp nnoremap <silent> <buffer> <cr> :CSearchContext<cr>
" }}}
" }}}

" UltiSnips Setup {{{
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsSnippetDirectories=['UltiSnips',"bundle/vim-snippets/UltiSnips"]
  let g:UltiSnipsExpandTrigger="<C-s>"
  let g:UltiSnipsJumpForwardTrigger="<C-s>"
  let g:UltiSnipsJumpBackwardTrigger="<C-e>"
  let g:UltiSnipsListSnippets="<F4>"
  " From: https://github.com/Valloric/YouCompleteMe/issues/420
"   let g:ulti_expand_or_jump_res = 0
"   function ExpandSnippetOrCarriageReturn()
"     let snippet = UltiSnips#ExpandSnippetOrJump()
"     if g:ulti_expand_or_jump_res > 0
"       return snippet
"     else
"       return "\<CR>"
"     endif
"   endfunction
" inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
" }}}

" Supertab Setup {{{
  " TIP: Ctrl-E to return to original without auto-complete
  " let g:SuperTabDefaultCompletionType = 'context'
  " let g:SuperTabClosePreviewOnPopupClose = 1 " close scratch window on autocompletion
" }}}

"General Completer Options {{{
" don't give |ins-completion-menu| messages.  For example,
" -- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c

" }}}
" CompleterParameter Setup {{{

  " inoremap <silent><expr> ( complete_parameter#pre_complete("()")
  " let g:complete_parameter_use_ultisnips_mapping = 1
" }}}
"
" Jedi Setup {{{
" let g:jedi#popup_on_dot = 0
" let g:jedi#auto_initialization = 1
" let g:jedi#show_call_signatures = 2
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#show_call_signatures_delay = 0
" if &rtp =~ '\<jedi\>'
"     augroup JediSetup
"         au!
"         au FileType python
"             \ setlocal omnifunc=jedi#completions  |
"             \ call jedi#configure_call_signatures()
"     augroup END
" endif
" }}}

" YouCompleteMe Setup {{{
  " let g:loaded_youcompleteme = 1
  let g:ycm_python_binary_path = 'python' " For JediHTTP using the right (virtualenv) python. :YcmCompleter RestartServer <path_to_python_bin>
  let g:ycm_collect_identifiers_from_tags_files = 0 " Seems ycmd is 70% faster at these. Switch to 0 if massive python memory consumption
  " let g:ycm_add_preview_to_completeopt = 1
  "if preview is slow {
  let g:ycm_add_preview_to_completeopt = 0
  set completeopt-=preview
  "}
  " let g:ycm_confirm_extra_conf = 0
  let g:ycm_seed_identifiers_with_syntax = 1
  " The default: let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
  " let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  " let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_min_num_of_chars_for_completion = 4
  " let g:ycm_autoclose_preview_window_after_completion = 1
  " let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
  " let g:ycm_extra_conf_globlist = ['~/Software/*', '~/repository_local/*']
  " This completely removes ycm.
  " let g:ycm_filetype_specific_completion_to_disable = {
  "             \ 'gitcommit': 1 ,
  "             \ 'cpp': 1
  "             \}
  "
  let g:ycm_auto_trigger=1  " This turns off the identifier comp (as you type) and semantic (.,->) auto trigger. Use <C-Space>, or <C-b> for trigger manually

  function! Switch_ycm_auto_trigger()
    if g:ycm_auto_trigger == 0
      let g:ycm_auto_trigger = 1
    else
      let g:ycm_auto_trigger = 0
    endif
  endfunction

  nnoremap <leader>y :call Switch_ycm_auto_trigger()<CR>

  "DEFAULT: let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_invoke_completion = '<C-w>'
  " nnoremap <leader>jd :YcmCompleter GoToDeclaration<cr>
  " nnoremap <leader>kd :YcmCompleter GoToDefinitionElseDeclaration<cr>
  " nnoremap <leader> :YcmCompleter GoToDefinition<cr>
  nnoremap <leader>jf :YcmCompleter FixIt<cr>
  nnoremap <leader>jj :YcmCompleter GoTo<cr>
  nnoremap <leader>jr :YcmCompleter GoToReferences<cr>
  nnoremap <leader>jh :YcmCompleter GetDoc<cr>
  nnoremap <leader>jt :YcmCompleter GetType<cr>
  nnoremap <leader>jp :YcmCompleter GetParent<cr>
  nnoremap <silent> gf :YcmCompleter FixIt<cr>
  nnoremap <silent> gd :YcmCompleter GoTo<cr>
  nnoremap <silent> gr :YcmCompleter GoToReferences<cr>
  nnoremap <silent> gh :YcmCompleter GetDoc<cr>
  nnoremap <silent> gt :YcmCompleter GetType<cr>
  nnoremap <silent> gp :YcmCompleter GetParent<cr>
  "close preview
  nnoremap <leader>jc :pc<cr>
" if using Jedi, disable ycm python
let g:ycm_filetype_specific_completion_to_disable = {
 \ 'gitcommit': 1,
 \ 'python': 1,
 \ }
" YCM+eclim {{{
  " Use default completefunc (<c-x><c-u>) to work with both YCM, and eclim.
  " From the docs.
  " let g:EclimCompletionMethod = 'omnifunc'
  " But it is too intrusive/slow calling eclipse indexer all the time, so we disable semantic completion.
  " We can still call it manually with <C-X><C-O> or the key in g:ycm_key_invoke_completion
" To remove clang_completer move hooks.py to hooks.py.BACKUP
  " let g:ycm_filetype_specific_completion_to_disable = {
  "       \ 'cpp': 1
  "       \}
" }}}

" YCM+UltiSnips+SuperTab {{{
  " let g:SuperTabDefaultCompletionType = '<C-n>'  " This overrides the default 'Context' for SuperTab+UltiSnips+Eclim
  " let g:SuperTabCrMapping = 0
" }}}



" Multiple-Cursors setup {{{
  function! Multiple_cursors_before()
      let g:ycm_auto_trigger = 0
  endfunction

  function! Multiple_cursors_after()
      let g:ycm_auto_trigger = 1
  endfunction
" }}}
" }}} End YCM related

" Neovim options {{{
if has('nvim')
  set inccommand=split
endif
" }}}
" COLOUR OPTIONS: {{{
" set t_Co=256
" colorscheme desert256
" colorscheme desert-warm-256
" let base16colorspace=256
" colorscheme base16-default-dark
colorscheme molokai
let g:molokai_original=1
let g:rehash256=1
" colorscheme jellybeans
set background=dark
if has('termguicolors') " Truecolor. modern vim or nvim only.
  set termguicolors
  " vim only: RGB colors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   " colorscheme base16-monokai
"   source ~/.vimrc_background
"   " modified this in base16-monokai
"   " call <sid>hi("IncSearch",    s:gui00, s:gui03, s:cterm00, s:cterm03,  "undercurl", "")
" endif
"}}}
" SYNTAX {{{
syntax spell toplevel
syntax enable
set synmaxcol=400 " syntax highlight is really slow for monstruously long lines.
setlocal spell spelllang=en_us
set nospell
map <F12> :setlocal spell! spelllang=en_us<CR>
" hi stuff must be after syntax (not colour)
hi ColorColumn ctermbg=DarkGray guibg=#2c2d27
au FileType c,cpp setlocal colorcolumn=81
" hi CursorLine cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>cl :set cursorline!<CR>

if version >= 702
  autocmd BufWinLeave * call clearmatches() " Solve performance problems with multiple syntax match.
endif
"}}}

" Render options (for Slow machines) {{{
" set relativenumber " In relative way (SLOW rendering!!!!!) :((
set lazyredraw
" }}}
" Basic {{{
set number           " Show line numbers
" set autochdir        " Set cd to current file directory. Mess with plugins
set pastetoggle=<F8> " Paste without autoindent
set mouse=a          " Automatic enable mouse
set textwidth=0
set wrapmargin=0     " Turns off physical line wrapping (automatic insertion of newlines)
set laststatus=2     " Status line always visible (useful with vim-airline)
set wrapscan         " Search next/ Search previous are cyclic.
set belloff=all      " Disable all kind of bells, including beep in gVim.
" set clipboard=autoselect,unnamed,unnamedplus,exclude:cons\|linux  " Clipboard is copied to unnamed register (")
" set clipboard+=unnamedplus
set title
set diffopt+=vertical " Gdiff open in vertical.
" wrap on in diffs
autocmd FilterWritePre * if &diff | setlocal wrap | endif
set splitright
set splitbelow
set timeoutlen=500 " timeoutlen : time to wait for chain character (leader, etc) Default is 1000, 1 sec
set hid            " Send files to buffer instead of closing them -- e,n ... commands.
set wildmode=list:longest,full
set noshowmode " Don't show INSERT/VISUAL in command line.
"}}}
" Utils/Buffers {{{
" Workaround to avoid setting autochdir:
" typyng zc in command mode expand to e current_directory.
cnoremap zc e <c-r>=expand("%:h")<cr>/
" <Leader><Enter> in quickfix to open a vertical split.
" autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L
" }}}
" Searching {{{
" Search visual selection (problems with end of line ^M character)
vnoremap // y/<C-R>"<CR>
vnoremap S y:%S/<C-R>"/
set gdefault   " avoid to /g at the end of search.
set ignorecase " ignore case
set smartcase  " except when there is a case on the query
set hlsearch   " highlight search
set incsearch  " incremental search
"}}}
" Inser White Space in normal mode with s space {{{
nnoremap s<space> i<space><esc>
" }}}
" Aesthetics {{{
set list
set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set scrolloff=20                         " 999 keeps the cursos in the middle.
" Autocomplete window: show preview win, show menu with 1 match, insert longest match
" set completeopt=preview,menuone,longest,noselect
set completeopt+=noselect
set previewheight=20        " omnicompletion and fugitive window.
set pumheight=30            " limit popup menu height
set concealcursor=nv        " expand concealed characters in insert mode solely
" Open QuickFix horizontally at they very bottom with line wrap
au FileType qf wincmd J | setlocal wrap
" au FileType qf wincmd L| setlocal wrap
" au FileType qf setlocal wrap
" Preview window with line wrap
" au BufWinEnter * if &previewwindow | setlocal wrap | resize line('$') | endif
au BufWinEnter * if &previewwindow | setlocal wrap | endif
" }}}
" Undofile {{{
set undofile  " Maintain a undofile to keep changes between sessions.
set undodir=~/.vim/undo/
" }}}

" Tabs and whitespaces {{{
set autoindent
set backspace=indent,eol,start
" set matchpairs+=<:>
"}}}
" Indent {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Indent specific commands {{{
command! Indent2 set tabstop=2 | set shiftwidth=2 | set softtabstop=2
command! Indent4 set tabstop=4 | set shiftwidth=4 | set softtabstop=4
command! Indent8 set tabstop=8 | set shiftwidth=8 | set softtabstop=8
command! Indent2L setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal softtabstop=2
command! Indent4L setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal softtabstop=4
command! Indent8L setlocal tabstop=8 | setlocal shiftwidth=8 | setlocal softtabstop=8
command! IndentITK execute 'Indent2' | set cinoptions={1s,:0,l1,g0,c0,(0,(s,m1 | call SetClangFormatITK()
" }}}
" }}}
" General Maps: {{{
" Escape remap (Ctrl-C doesnt work well in some plugins) (not reliable)
noremap <C-c> <Esc>
" Smash Escape
inoremap jk <ESC>
inoremap kj <ESC>
" To navigate trough visually wrapped lines.
nnoremap j gj
nnoremap k gk
" To keep the old behavior in gj, gk
nnoremap gj j
nnoremap gk k
" To use with bracketing/indendation with brackets.
imap <c-F> <C-g>g
vnoremap <C-c> <Esc>
" inoremap <Leader>k <ESC>kI<TAB>
" inoremap <Leader>h <c-o>h
" Tag Navigation
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
" TimeStamps
" nnoremap <leader>ts "=strftime("%F")<CR>P
inoremap <F8> <C-R>=strftime("%a %d %b %Y")<CR>
" Copy filename to clipboard {{{
  function CopyAbsolutePath()
    " absolute path (/something/src/foo.txt)
    let @+=expand("%:p")
  endfunction

  function CopyRelativePath()
   " relative path (src/foo.txt)
    let @+=expand("%")
  endfunction

  function CopyFilename()
    " filename (foo.txt)
    let @+=expand("%:t")
  endfunction

  function CopyDirectoryPath()
    " directory name (/something/src)
    let @+=expand("%:p:h")
  endfunction

  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cf :call CopyAbsolutePath()<CR>
 " relative path (src/foo.txt)
  nnoremap <leader>cfr :call CopyRelativePath()<CR>
  " filename (foo.txt)
  nnoremap <leader>cfl :call CopyFilename()<CR>
  " directory name (/something/src)
  nnoremap <leader>cfd :call CopyDirectoryPath()<CR>
  com! -nargs=0 CopyFilename call CopyFilename()

"}}}
" Move between tabs {{{
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
let g:lasttab = 1
nmap <leader>t :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
"}}}
" setlocal foldmethod {{{
noremap <leader>ss :setlocal foldmethod=syntax
" }}}
" map alternatefile, ctrl-^ ctrl-6  to more comfortable ctrl-;
nnoremap <C-N> <C-^>
"End of General Maps}}}

" Return to last edit position when opening files (You want this!) Obsolete:
" plugin:restore_view does this. {{{
" autocmd BufReadPost *
"      \ if line("'\"") > 0 && line("'\"") <= line("$") |
"      \   exe "normal! g`\"" |
"      \ endif
" " Remember info about open buffers on close, in ~/.viminfo
" set viminfo^=%
"}}}
" vimgrep mappings {{{
" => vimgrep searching and cope displaying https://amix.dk/vim/vimrc.html
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
"}}}

" Makeprg options functions (homemade) {{{
" BuildFolderSearch {{{
function! BuildFolderSearch()
    if !empty(glob("../build"))
        let g:buildFolder='../build'
    elseif !empty(glob("../build-release"))
        let g:buildFolder='../build-release'
    elseif !empty(glob("../build-debug"))
        let g:buildFolder='../build-debug'

    elseif !empty(glob("../../build"))
        let g:buildFolder='../../build'
    elseif !empty(glob("../../build-release"))
        let g:buildFolder='../../build-release'
    elseif !empty(glob("../../build-debug"))
        let g:buildFolder='../../build-debug'

    elseif !empty(glob("../../../build"))
        let g:buildFolder='../../../build'
    elseif !empty(glob("../../../build-release"))
        let g:buildFolder='../../../build-release'
    elseif !empty(glob("../../../build-debug"))
        let g:buildFolder='../../../build-debug'

    elseif !empty(glob("../../../../build"))
        let g:buildFolder='../../../../build'
    elseif !empty(glob("../../../../build-release"))
        let g:buildFolder='../../../../build-release'
    elseif !empty(glob("../../../../build-debug"))
        let g:buildFolder='../../../../build-debug'

    elseif !empty(glob("../../../../../build"))
        let g:buildFolder='../../../../../build'
    elseif !empty(glob("../../../../../build-release"))
        let g:buildFolder='../../../../../build-release'
    elseif !empty(glob("../../../../../build-debug"))
        let g:buildFolder='../../../../../build-debug'
    endif

    let g:buildFolder = fnamemodify(g:buildFolder, ':p')
    return g:buildFolder
endfunction
"}}}
"SetNThreads {{{
function! SetNThreads()
  if !empty($NUMBER_OF_PROCESSORS)
    " this works on Windows and provides a convenient override mechanism otherwise
    let g:n_threads = $NUMBER_OF_PROCESSORS + 0
  elseif filereadable('/proc/cpuinfo')
    " this works on most Linux systems
    let g:n_threads = system('grep -c ^processor /proc/cpuinfo') + 0
  elseif executable('/usr/sbin/psrinfo')
    " this works on Solaris
    let g:n_threads = system('/usr/sbin/psrinfo -p')
  else
    " default to single process if we can't figure it out automatically
    let g:n_threads = 1
  endif
endfunction
"}}}
"SetMakeprg {{{
function! SetMakeprg()
  call SetNThreads()

  if exists("g:buildFolder")
    let buildsys="make --stop --no-print-directory"
    if filereadable((g:buildFolder) . '/rules.ninja')
      let buildsys="ninja"
    endif
    let &makeprg= buildsys . (g:n_threads > 1 ? (' -j'.(g:n_threads)) : '') . ' -C ' . (g:buildFolder)
  else
    call BuildFolderSearch()
    call SetMakeprg()
  endif
endfunction
"}}}
" BuildFolderAppend(str) {{{
function! BuildFolderAppend(str)
  let g:buildFolder = g:buildFolder . (a:str)
endfunction
"}}}
" end of makeprg functions }}}
"
"Vim-grepper Setup {{{
" initialize g:grepper with defaults
let g:grepper = {}
runtime autoload/grepper.vim
" When use -tool=git, search from root directory.
let g:grepper.git =
\ { 'grepprg': 'git grep -nI $* -- `git rev-parse --show-toplevel`' }
nnoremap <leader>GG :Grepper -tool git<cr>
nnoremap <leader>GA :Grepper -tool ag<cr>
nnoremap <leader>GS :Grepper -tool agSF<cr>
"}}}
" Cppcheck
function! SetWarningType(entry)
  if a:entry.type =~? '\m^[SPI]'
    let a:entry.type = 'I'
  endif
endfunction

function! SetSourceFolder(path)
    let g:sourceFolder=a:path

    " Set vim-grepper {{{
    if !has_key(g:grepper, 'tools')
      let g:grepper.tools = []
    endif
    " Ag
    if index(g:grepper.tools,'agSF') == -1
      let g:grepper.tools = g:grepper.tools + ['agSF']
    endif
    let g:grepper.agSF = g:grepper.ag
    let g:grepper.agSF =
          \ { 'grepprg': 'ag --vimgrep $* ' . g:sourceFolder }
    execute 'command! -nargs=+ -complete=file GrepperAgSF'
          \ 'Grepper -noprompt -tool agSF -query <args>'
    " git
    " let root = systemlist('git -C ' . g:sourceFolder . ' rev-parse --show-toplevel')[0]
    if !v:shell_error
      if index(g:grepper.tools,'gitSF') == -1
        let g:grepper.tools = g:grepper.tools + ['gitSF']
      endif
      let g:grepper.gitSF = g:grepper.git
      let g:grepper.gitSF =
            \ { 'grepprg': 'git -C ' . g:sourceFolder . ' grep -nI $* | sed s:^:' . g:sourceFolder .'/: --' }
    endif
    execute 'command! -nargs=+ -complete=file GrepperGitSF'
          \ 'Grepper -noprompt -tool gitSF -query <args>'
    " }}}
endfunction
com! -nargs=1 -complete=file SourceFolder call SetSourceFolder(<q-args>)

" asyncrun setup {{{
" For using it with errorformat (display errors)
let g:asyncrun_auto = "make"
" augroup QuickfixStatus
" 	au! BufWinEnter quickfix setlocal
" 		\ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
" augroup END
let g:asyncrun_trim = 1 " trim empty lines
" better quickfix toogle:
noremap <F9> :call asyncrun#quickfix_toggle(8)<cr>
let g:toggle_list_copen_command="call asyncrun#quickfix_toggle(8)"
" vim-fugive (using Make) async, from: https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
com! ClearErrorSigns execute "sign unplace * buffer=" . bufnr("%")
" }}}

" Linters {{{
" Ale {{{
" Disabled by default
let g:ale_enabled = 0
" (optional, for completion performance) run linters only when I save files
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
" show loclist vertical
" let g:ale_list_vertical = 1
let g:ale_linters = {
      \ 'cpp': ['clangtidy'],
      \ 'python':['flake8']
      \}
" \ 'javascript': ['eslint'],
" flake8 {{{
" E302: comment/lines (expected 2 lines...)
let g:ale_python_flake8_options='--ignore E302 --max-line-length=120'
"}}}
" clangtidy {{{
" Disable specific projects checks. default: = ['*']
" Other option is to enable only checks that you are interested, but we might
" miss new checkers added in the future.
let g:ale_cpp_clangtidy_checks = [
      \ '-android-*',
      \ '-boost-*',
      \ '-fuchsia-*',
      \ '-google-*',
      \ '-llvm-*',
      \ '-objc-',
      \ ]
com! -nargs=1 -complete=file HeaderSource let g:ale_cpp_clangtidy_header_sourcefile=<q-args> | let b:ale_cpp_clangtidy_header_sourcefile=<q-args>
" let g:ale_pattern_options = {
"       \   '\.h$': {
"       \       'ale_linters': {'cpp': ['clangtidy']},
"       \       'ale_cpp_clangtidy_options': '~/repository_local/FFT-from-image-compute-radial-intensity/src/apps/RadialIntensity/test/test_saxs_sim_functional.cpp',
"       \   },
"       \}
" }}} end of tidy
" }}} end of ale
" }}}
" Build
  call SetNThreads()
  let g:BuildOnSave  = 0 " To lunch 'Neomake! build' on save (only cpp,c)

"  Error formats strings {{{
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
"}}}

" Build/Compiler/Error options {{{
  function! SetErrorFormatClang()
    let &errorformat = ErrorFormatClang() . ',' . ErrorFormatCMake()
  endfunction

  function! SetErrorFormatGCC()
    let &errorformat = ErrorFormatGCC() . ',' . ErrorFormatCMake()
  endfunction

  function! MakeArgumentsDefault()
      let lst = ['make', (g:n_threads > 1 ? ('-j'.(g:n_threads)) : ''), '--stop', '--no-print-directory']
      return lst
  endfunction

  function! AppendBuildFolder(lst)
    return a:lst + ['-C', g:buildFolder]
  endfunction

  function! MakeString()
    let lst_default = MakeArgumentsDefault()
    let lst = AppendBuildFolder(lst_default)
    return join(lst)
  endfunction

  function! NinjaString()
    let lst = 'ninja -C' . g:buildFolder
    if exists("g:buildTarget")
      let lst = lst . ' ' . g:buildTarget
    endif
    return lst
  endfunction

  " Use make by default
  let g:bCommand = 'make'
  function! WriteBuild()
    execute "normal w"
    if g:bCommand == 'make'
      execute "AsyncRun! " . MakeString()
    endif
    if g:bCommand == 'ninja'
      execute "AsyncRun! " . NinjaString()
    endif
  endfunction
  com! -nargs=0 WB call WriteBuild()

  function! ToggleBuildOnSave()
    if g:BuildOnSave == 1
      let g:BuildOnSave = 0
    else
      let g:BuildOnSave = 1
    endif
  endfunction

  function! AutoBuild()
    if g:BuildOnSave == 1
      call WriteBuild()
    endif
  endfunction

" }}}
" Make and Neomake maps and autocommands Setup {{{
  let g:DispArg = ''
  fun! DispArg(args)
    let g:DispArg = a:args
  endfunction
  " Hack to have file autocompletion in command line (or in q:)
  com! -nargs=* -complete=file DispArgs call DispArg(<q-args>)
  " nnoremap <silent> <Leader>r :execute 'Dispatch ' . g:DispArg<CR>
  " au FileType c,cpp au BufWinEnter * call SetNThreads()
  " Call NeomakeBuild() on save if g:BuildOnSave=1
  nnoremap <silent> <Leader>n :execute "AsyncRun! " . NinjaString()<CR> <bar> let g:bCommand = 'ninja'<CR>
  au FileType c,cpp nnoremap <silent> <Leader>e :execute "AsyncRun! " . MakeString()<CR> <bar> let g:bCommand = 'make'<CR>
  au FileType c,cpp nnoremap <silent> <Leader>nt :call ToggleBuildOnSave()<CR>
  com! -nargs=1 -complete=file BuildFolder let g:buildFolder=<q-args>
  com! -nargs=1 BuildTarget let g:buildTarget=<q-args>
" }}}
" Useful commands: {{{
" write to open file that requires sudo
" :w !sudo tee %
" :earlier 15m

" search {{{
" search current word under the cursor on normal mode.
" search in visual mode the yank register (/)
" Useful for:
" - Replace
" - A handy way to show all occurrences with inccomand=split in neovim
nnoremap <Leader>k :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>k :s/<C-r>"/<C-r>"/
" }}}
" }}}

" Task related commands {{{
com! Task exec "!task"
com! Tasklog exec "!cat ~/tasks.log | tail -n 10"
com! Tasknext exec "!task | head -n 1"
com! -nargs=1 Taskfinish exec "!task -f <q-args>"
com! Taskedit exec "e ~/tasks"
com! Tasklogedit exec "e ~/tasks.log"
" }}}

function! CommentsLightBlue()
 execute 'highlight Comment ctermfg=LightBlue guifg=LightBlue'
endfunction
com! ClearQuickFix call setqflist([])
" vim:foldmethod=marker:foldlevel=2
