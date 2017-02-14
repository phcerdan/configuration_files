set nocompatible
set nofoldenable    " disable folding. Slow. Even with fastfold
syntax on
let mapleader=" "
" For R (and latex?) plugins
let maplocalleader=";"

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
" Debuggers: {{{
" " SLOW{{{
" Plug 'vim-scripts/Conque-GDB' " ConqueGdb embeds a gdb terminal in a vim buffer. Best approach ever.
" " Conque-GDB Setup {{{
" " Set localsyntax of ConqueGDB buffer to cpp
"   let g:ConqueTerm_Syntax = 'cpp'
"   let g:ConqueGdb_Leader='\'
"   let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
"   let g:ConqueTerm_CloseOnEnd = 0    " close conque when program ends running
"   let g:ConqueTerm_StartMessages = 1 " display warning messages if conqueTerm is configured incorrectly
"   let g:ConqueGdb_SrcSplit = 'right' " Split the source code 'xxx' of GDB window.
"   " Delete all buffers opened by Conque
"   nnoremap <silent> <Leader>// :ConqueGdbBDelete<CR>
"   " nnoremap <silent> <Leader>/Y :ConqueGdbCommand y<CR>
"   " nnoremap <silent> <Leader>/N :ConqueGdbCommand n<CR>
" " }}}
" let $PYTHONPATH.=":/usr/lib/python2.7/site-packages/lldb"
" Plug 'critiqjo/lldb.nvim'
" " , has('nvim') ? {} : { 'on': [] } " lldb improved (require nvim)
" " lldb improved Setup {{{
"   nmap <Leader>db <Plug>LLBreakSwitch
"   nnoremap <Leader>dd :LLmode debug<CR>
"   nnoremap <Leader>dD :LLmode code<CR>
"   nnoremap <Leader>dc :LL continue<CR>
"   nnoremap <Leader>dn :LL next<CR>
"   nnoremap <Leader>dni :LL thread step-over-inst<CR>
"   nnoremap <Leader>ds :LL step<CR>
"   nnoremap <Leader>dsi :LL thread step-inst<CR>
"   nnoremap <Leader>df :LL finish<CR>
"   nnoremap <Leader>dI :LL process interrupt<CR>
"   nnoremap <Leader>dK :LL process kill<CR>
"   nnoremap <Leader>dp :LL print <C-R>=expand('<cword>')<CR>
"   vnoremap <Leader>dp :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>
"   nnoremap <Leader>dle :LLsession bp-set<CR>
"   nnoremap <Leader>dlw :LLsession bp-save<CR>
"   nnoremap <Leader>dlr :LLsession reload<CR>
"   nnoremap <Leader>dll :LLsession load
" " }}}
" "}}} SLOW
"}}}
" Organization/Note taking {{{
" Plug 'vimwiki/vimwiki'  " vim-wiki, natural substitute of org-mode in vim.
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
" Note-taking utilities Plugins  {{{
  " Plug 'vim-scripts/utl.vim'            " Universal Text Linking (for urls and text linking)
  " Plug 'tpope/vim-speeddating'          " Modify dates with C-A, C-X (like integers)
  " Plug 'mattn/calendar-vim'             " Calendar <localleader>cal
  " Plug 'vim-scripts/SyntaxRange'        " Syntax Highlighting in code blocks
" }}}
" }}}
" Advanced {{{
Plug 'metakirby5/codi.vim'              " Interactive scratchpad. Needs real time interpreter. Cling in c++.
" }}}
Plug 'Raimondi/delimitMate'             " Auto-pair like script
Plug 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plug 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
Plug 'tpope/vim-surround'               " cs\"' to change \" for ', or yss) putting the sentence into brackets. The first s is for surround.
Plug 'tpope/vim-obsession'              " Save sessions :Obsess, Restore: vim -S, or :source . Also used by tmux-resurrect
Plug 'tomtom/tcomment_vim'              " Toggle comment with gcc
Plug 'tpope/vim-sleuth'                 " Automatic detection of indent, based on current file or folder files with same extension.
Plug 'tpope/vim-abolish'                " substitutions with plurals, cases, etc.
Plug 'tpope/vim-repeat'                 " repeat commands(normal mode) with .
Plug 'vim-scripts/visualrepeat'         " works with visual mode too.
Plug 'tpope/vim-dispatch'               " Async building. :Make, :Make!, Dispatch for running things.https://github.com/tpope/vim-dispatch
Plug 'tpope/vim-eunuch'  " Move/Rename/UNIX shell goodies.
" Plug 'radenling/vim-dispatch-neovim'    " STILL TOO EXPERIMENTAL Add support to running in a nvim :terminal
Plug 'benekastah/neomake', has('nvim') ? {} : { 'on': [] } " Async building for neovim. :Make, :Make! GOLD
Plug 'vim-scripts/restore_view.vim'     " Restore file position and FOLDS. Testing... slow?
" restore_view Setup{{{
  set viewoptions=cursor,folds,slash,unix
" }}}
Plug 'milkypostman/vim-togglelist'      " Default mapping to <Leader>q, <Leader>l GOLD
Plug 'ntpeters/vim-better-whitespace'   " Highlight whitespaces and provide StripWhiteSpaces()
" Better-whitespace Setup {{{
"}}}
Plug 'drn/zoomwin-vim'
" ZoomWin Setup {{{
  nnoremap <Leader>z :ZoomWin<cr>
" }}}
" Align and Tabularize: {{{
Plug 'terryma/vim-multiple-cursors'     " <C-n> to select next word for multiple modification. Sublime style. Good!
Plug 'junegunn/vim-easy-align'
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

Plug 'Yggdroot/indentLine'
  " indentLine Setup {{{
  let g:indentLine_char = '|'
  " let g:indentLine_leadingSpaceChar = '.'
  " let g:indentLine_leadingSpaceEnabled = 1
  let g:indentLine_faster = 1
  let g:indentLine_color_term = 239
  let g:indentLine_enabled = 1
" }}}
" }}}
" File Navigation and Search: {{{

" Plug 'francoiscabrol/ranger.vim'        " Ranger example converted to a plugin. :Ranger
" Plug 'justinmk/vim-dirvish'             " Minimalist file-explorer, aims to replace vim-built-in netwr.
" vim-dirvish Setup {{{
" Incompatible with autochdir option: https://github.com/justinmk/vim-dirvish/issues/19
" }}}
Plug 'scrooloose/nerdtree'              " Folder structure viewer
" NerdTREE Setup {{{
  nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
  nnoremap <silent> <Leader>N :NERDTree<CR>
" }}}
Plug 'mhinz/vim-grepper' " Modular approach. Default is ag.
" Plug 'mileszs/ack.vim' " Ag is obsolete. Use this.
Plug 'rking/ag.vim'   " Silver searcher integration (similar to ack / grep), search in directory for words. To install silver_searcher: https://github.com/ggreer/the_silver_searcher
"Ack/Ag Setup {{{
"
  if executable('ag')
    " let g:ackprg = 'ag --vimgrep --smart-case'
    " cnoreabbrev Ag Ack
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
    nnoremap <silent> <Leader>/ :execute 'Ag ' . input('Ag/')<CR>
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  endif
"}}}
Plug 'ctrlpvim/ctrlp.vim', has('fzf') ? {} : { 'off': [] } " Ctrlp to search for / open files. Worse than zfz.
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
Plug 'junegunn/fzf', { 'do': './install --all' } " Command line (zsh, etc) fuzzy searcher. Better than CtrlP (only unix)
Plug 'junegunn/fzf.vim'
" fzf Setup {{{
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
  \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), g:fzf#vim#default_layout))
" Specialized for ITK.
let g:ITKFolder = '~/Software/ITK/ITK-development'
function! s:with_itk_git_root()
  let root = systemlist('git -C '. g:ITKFolder . ' rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
command! -nargs=* IAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_itk_git_root(), g:fzf#vim#default_layout))
command! -nargs=* IFiles
  \ call fzf#vim#files(<q-args>, extend(s:with_itk_git_root(), g:fzf#vim#default_layout))
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


  function! SearchWordWithAg()
    let ag_command = 'Ag'
    execute ag_command expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let ag_command = 'Ag'
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
Plug 'majutsushi/tagbar'
" Tagbar Setup {{{
  nnoremap <silent> <Leader>bb :TagbarToggle<CR>
  let g:tagbar_sort=0 "Keep order of file.
" }}}
" }}}
"Color Schemes and status-line {{{
Plug 'rainux/vim-desert-warm-256'
Plug 'justinmk/molokai'
Plug 'nanotech/jellybeans.vim'
" Jellybeans setup{{{
  let g:jellybeans_use_term_italics = 1
  " let g:jellybeans_use_lowcolor_black = 0
" }}}
Plug 'chriskempson/base16-vim'
" Plug 'itchyny/lightline.vim'
" " lightline setup {{{
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ }
" }}}
Plug 'vim-airline/vim-airline'                " Colourful status-line.
Plug 'vim-airline/vim-airline-themes'
" Airline Setup {{{
  let g:airline_theme='wombat'
  let g:airline#extensions#tabline#enabled = 1 "Show tabs if only one is enabled.
  let g:airline#extensions#tabline#show_splits = 1 "enable/disable displaying open splits per tab (only when tabs are opened). >
  let g:airline#extensions#tabline#show_buffers = 1 " enable/disable displaying buffers with a single tab
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
  " To show full path: default is %f instead of %F.
  " let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
  let g:airline_powerline_fonts = 1
" }}}
Plug 'gcmt/taboo.vim'   " Rename tabs
 " Taboo Options {{{ :TabooRename, TabooOpen aname
 " To restore tab names.
   " let g:airline#extensions#taboo#enabled = 0
   " let g:loaded_taboo = 1
   let g:taboo_tabline=0
   set sessionoptions+=tabpages,globals
 " }}}
"}}}
" TMUX {{{
Plug 'edkolev/tmuxline.vim'             " Status line for tmux (Airline compatible)
Plug 'christoomey/vim-tmux-navigator'   " Navigating vim/tmux with same keys. Default keys are <c-hjkl>
Plug 'jpalardy/vim-slime'               " Slime (emacs). Send/Copy from vim to other pane
" vim-slime Setup {{{
  let g:slime_target = "tmux"
  let g:slime_python_ipython = 1
  " :SlimeConfig socket name is usually default.
  " send to: :5.2 <- Window 5, second pane. or :5.%45, if you know the PaneId
  " from echo $TMUX_PANE
  command! TmuxSockets silent! !lsof -U | grep "^tmux"
" }}}
Plug 'benmills/vimux'                   " Call tmux from vim (used for calling emacs org-mode)
" Vimux Setup {{{
  let g:VimuxHeight = "40" " Default is 20
  let g:VimuxUseNearest = 1  " With 0 always split, with 1 attach if pane exist
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
  nnoremap <Leader>y :call VimuxSwitchOrRun("orgclient")<CR>
  nnoremap <Leader>Y :call VimuxCloseOrgMode()<CR>
" }}}
" Tmuxline Setup {{{
  let g:tmuxline_powerline_separators = 0
  " Tmux Navigator tips {{{
  " <Ctrl-w b> to go to bottom right window (TagBar). Or <Ctrl-w 2j>
  " <Ctrl-w t> to go to top left window.(NERDtree). Or <Ctrl-w 2h>
  " TIP: Use <Ctrl-\> to go to last split, specially useful with TabBar.
  " }}}
" }}}
" }}}
" Buffer Related {{{
" Switch to latest used buffer
nnoremap <Leader>h :b#<CR>
Plug 'vim-scripts/BufOnly.vim'          " :BOnly deltes all buffers except current one.
Plug 'moll/vim-bbye'                    " Bdelete, as Bclose, deleting buffers without deleting windows.
" vim-bbye Setup {{{
  command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
  nnoremap <Leader>d :Bdelete<CR>
  " Close buffer and window (split)
  noremap <Leader>q :Bclose<CR><c-W>c
"}}}
"}}}
" Diff tools {{{
Plug 'AndrewRadev/linediff.vim' " :Linediff in v-selection (x2) will compare chunks
" }}}
" Version Controlling {{{
Plug 'airblade/vim-gitgutter'
" Gitgutter Setup {{{
" let g:loaded_gitgutter=1 " Slow, don't load it.
" }}}
"}}}
" Language Specific Plugins and Settings {{{
" LATEX {{{
let g:tex_comment_nospell=1
let g:tex_conceal = ""
" au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak breakindent showbreak=..
au Filetype tex set spell wrap nolist textwidth=0 wrapmargin=0 linebreak showbreak=..
Plug 'lervag/vimtex' " Fork from Latex-box. Minimalistic ll to compile, lv to view, xpdf/zathura recommended.
" VimTex Setup {{{
" Neovim support: https://github.com/lervag/vimtex/issues/262 NOT READY
  " let g:vimtex_latexmk_callback = 0
  " Instead of nvim use: gvim -v --servername vimserver
  " (aliased to viserver)
  let g:vimtex_fold_enabled=1
  " let g:vimtex_fold_manual=1 " autofold is slow in vim, use FastFold instead
  " of this option!.
  let g:vimtex_latexmk_build_dir="output"
  let g:vimtex_latexmk_async=1 " Require gvim --servername vimserver main.tex
  let g:vimtex_latexmk_preview_continuosly=1 " -pvc option in latexmk
  let g:vimtex_quickfix_ignored_warnings = [
      \ 'Underfull',
      \ 'Overfull',
      \ 'specifier changed to',
    \ ]
  let g:vimtex_quickfix_open_on_warning=0
  " zathura forwarding require: xdotool
  " let g:vimtex_view_general_viewer = 'mupdf'
  " For Okular {{{
  let g:vimtex_view_general_viewer = 'okular'
  " Forward:
  let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
  let g:vimtex_view_general_options_latexmk = '--unique'
  " Backward (Shift + LeftClick) in Okular
  " Configure Okular first: Settings, Okular Config, Editor:
  " gvim --servername vimserver --remote-silent +%l "%f"
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
" Plug 'Konfekt/FastFold' " auto fold is slow
" FastFold Setup {{{
  " let g:tex_fold_enabled = 1
  " let g:cpp_folding = 1
  " let g:vim_folding = 1
  " let g:python_folding = 1
  " let g:vimsyn_folding='af'
" }}}
"}}}
" R {{{
" Plug 'jalvesaq/R-Vim-runtime' " Included in vim,nvim binaries. But just in case...
" Plug 'jalvesaq/VimCom'      " Communication vim - R
" Plug 'jcfaria/Vim-R-plugin' " Too many <Leader> shortcuts???
Plug 'jalvesaq/Nvim-R' " Includes VimCom functionalities.
" R plugins Setup {{{
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
  let R_vsplit = 1
  let R_rconsole_width = 80
  let R_objbr_place = "script,left"
  let R_in_buffer = 0
  let R_applescript = 0
  let R_tmux_split = 1
  " let vimrplugin_r_path = "~/devtoolset/R/bin"
  if has("gui_running")
      inoremap <C-Space> <C-x><C-o>
  else
      inoremap <Nul> <C-x><C-o>
  endif
  vmap <Space> <Plug>RDSendSelection
  nmap <Space> <Plug>RDSendLine
" }}}
" }}}
" Python {{{
" To run current file.
au FileType python nnoremap <buffer> <Leader>e :exec '!python' shellescape(@%, 1)<cr>
" python-mode is just too heavy, you don't really need rope.
" Plug 'klen/python-mode', { 'branch': 'develop'}
" python-mode Setup {{{
  " let g:pymode_rope_completion = 0 " Use YCM instead
" }}}
Plug 'nvie/vim-flake8'
" , has('flake8') ? {} : { 'on': [] } " lint for python. Require flake8 installation
" vim-flake8 Setup {{{
" Default mapping is <F7>
  let g:flake8_show_in_gutter=1
  let g:flake8_show_in_file=1
" }}}
" vim-flake8 Setup {{{
  " let no_flake8_maps = 1
" }}}
" SLOW:
" Plug 'jmcantrell/vim-virtualenv'
" vim-virtualenv Setup {{{
  " let g:virtualenv_directory='/home/phc/repository_local'
"}}}
" }}}
" OpenCL {{{
Plug 'petRUShka/vim-opencl'
"}}}
"CUDA {{{
Plug 'cmaureir/snipmate-snippets-cuda' " snippets and simple syntax.
" Create a symlink inside vim-snippets/snippets pointing to
" snipmate-snippets-cuda/snippets/cu.snippets, and rename it as cuda.snippets.
au BufNewFile,BufRead *.cu  setlocal ft=cuda.cpp
"}}}
" Rails (Ruby) {{{
Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
" }}}
"Docker {{{
Plug 'ekalinin/Dockerfile.vim'
" }}}
" Git {{{
autocmd Filetype gitcommit setlocal spell textwidth=72
"}}}
" Markdown / vimwiki {{{
Plug 'phcerdan/vim-flavored-markdown'
autocmd BufNewFile,BufReadPost *.md,*.markdown set filetype=ghmarkdown.markdown
" au FileType markdown setlocal conceallevel=0
"}}}
" CMake {{{
Plug 'phcerdan/vim-cmake-syntax'
" }}}
" C++ {{{
" Map to reformat 'typedef' to 'using' (c++11)
let @t = "^dwf;bde^iusing \<c-R>\" = \e:s/\\s*;/ ;/g\<C-m>"
" set ft in files: {{{
au BufNewFile,BufRead *.txx setlocal ft=cpp
au BufNewFile,BufRead *.ih setlocal ft=cpp
"}}}
" Switch header-implementation {{{
" use ]f [f from Unimpaired instead
" map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR> " Togle cpp/h --only if they are at the same folder.
" }}}
" Shift+K to open cppman in a tmux split {{{
command! -nargs=+ Cppman silent! call system("tmux split-window cppman " . expand(<q-args>))
autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>
"}}}
Plug 'sbdchd/neoformat'
"{{{ neoformat Setup
let g:neoformat_cpp_itk = {
      \ 'exe': 'uncrustify',
      \ 'args': ['-c ~/repository_local/configuration_files/uncrustify_itk_aggressive_phcerdan.cfg','-q', '-l CPP', '-f'],
      \ }
let g:neoformat_enabled_cpp = ['itk', 'uncrustify', 'clangformat', 'astyle']
"}}}
au FileType c,cpp au BufReadPre,BufNewFile itk execute IndentITK
Plug 'octol/vim-cpp-enhanced-highlight' " Cpp improved highlight
" Plug 'justinmk/vim-syntax-extra'        " Syntax for c,c++.
Plug 'vim-scripts/DoxygenToolkit.vim'
" Eclim Setup {{{
" installation: http://eclim.org/install.html and
" dotfile: .eclimrc
  " let g:EclimLogLevel                    = 'debug'
  " Options: split, vsplit, edit
  let g:EclimDefaultFileOpenAction       = 'edit'
  let g:EclimCSearchSingleResult         = 'edit'
  let g:EclimBuffersDefaultAction        = 'edit'
  let g:EclimLocateFileDefaultAction     = 'edit'
  let g:EclimCCallHierarchyDefaultAction = 'edit'
  let g:EclimKeepLocalHistory            = 0
  let g:EclimFileTypeValidate = 0 " Avoid validation on save (memory expensive)
  au FileType c,cpp nnoremap <silent> <buffer> <cr> :CSearchContext<cr>

"}}}
" End of C++}}}
"End of Language specifics }}}
" AUTOCOMPLETERS {{{
Plug 'SirVer/ultisnips'                 " Awesomeness. Create your own snippets
Plug 'honza/vim-snippets'               " Merged cmake changes!
" UltiSnips Setup {{{
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsSnippetDirectories=['UltiSnips',"bundle/vim-snippets/UltiSnips"]
  " let g:UltiSnipsJumpBackwardTrigger="<c-k>"
  let g:UltiSnipsListSnippets="<Leader>11" "list ,l
  " Because remap of Tab, ctrl-i does not work as a jumplist-forward
  nnoremap <Leader>o <C-o>
  nnoremap <Leader>i :echo "jump list forward does not work, because TAB is remapped!"<CR>
" }}}
Plug 'ervandew/supertab'                " Tab to autocomplete.
" Supertab Setup {{{
  " TIP: Ctrl-E to return to original without auto-complete
  let g:SuperTabDefaultCompletionType = 'context'
  " let g:SuperTabClosePreviewOnPopupClose = 1 " close scratch window on autocompletion
" }}}
" YCM {{{
let completer = 'oblitum/YouCompleteMe'
" let completer = 'Valloric/YouCompleteMe'
Plug completer , { 'do': 'python2 ./install.py' }
" Plug completer , { 'do': 'cd ./third_party/ycmd ; patch -p1 < ~/repository_local/configuration_files/vim/cpp_trigger_patch.txt ; cd ../../ ; python2 ./install.py' }
" Plug completer , { 'do': 'python2 ./install.py --clang-completer' }
" Apply patch to allow c++ completion with templates (slower)
" Plug completer , { 'do': ' cd ./third_party/ycmd ; git apply ~/repository_local/configuration_files/vim/patch_cpp_incomplete.diff ; cd ../../ ; python2 ./install.py --clang-completer' }
" Plug completer , { 'do': 'python2 ./install.py --clang-completer --system-libclang' }
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" ctags must be called with --fields=+l (modified in git_templates/ctags)
" BUG in ycm about memory consuption with ctags, put it 0
" meanwhile: https://github.com/Valloric/YouCompleteMe/issues/595

" YouCompleteMe Setup {{{
  " let g:loaded_youcompleteme = 1
  let g:ycm_python_binary_path = 'python' " For JediHTTP using the right (virtualenv) python. :YcmCompleter RestartServer <path_to_python_bin>
  let g:ycm_collect_identifiers_from_tags_files = 1 " Seems ycmd is 70% faster at these. Switch to 0 if massive python memory consumption
  let g:ycm_add_preview_to_completeopt = 1
  " set completeopt-=preview
  " let g:ycm_confirm_extra_conf = 0
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_min_num_of_chars_for_completion = 4
  " let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
  "DEFAULT: let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_invoke_completion = '<C-b>'
  nnoremap <leader>j :YcmCompleter GoToDeclaration<cr>
  nnoremap <leader>k :YcmCompleter GoToDefinitionElseDeclaration<cr>
  " nnoremap <leader>d :YcmCompleter GoToDefinition<cr>
  nnoremap <leader>fi :YcmCompleter FixIt<cr>
  nnoremap <leader>gt :YcmCompleter GoTo<cr>
  nnoremap <leader>gd :YcmCompleter GetDoc<cr>
  nnoremap <leader>gy :YcmCompleter GetType<cr>

" YCM+eclim {{{
  " From the docs.
  let g:EclimCompletionMethod = 'omnifunc'
  " But it is too intrusive/slow calling eclipse indexer all the time, so we disable semantic completion.
  " We can still call it manually with <C-X><C-O> or the key in g:ycm_key_invoke_completion
" To remove clang_completer move hooks.py to hooks.py.BACKUP
  let g:ycm_filetype_specific_completion_to_disable = {
        \ 'cpp': 1
        \}
" }}}
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
" }}}
" Autocompleters END }}}

call plug#end()            " required
" vim-plug END }}}

" Neovim options {{{
if has('nvim')
  set inccommand=nosplit
endif
" }}}
" COLOUR OPTIONS: {{{
" set t_Co=256
" colorscheme desert256
" colorscheme desert-warm-256
" let base16colorspace=256
" colorscheme base16-default-dark
" colorscheme molokai
" let g:molokai_original=1
" let g:rehash256=1
colorscheme jellybeans
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
set autochdir        " Set cd to current file directory.
set pastetoggle=<F8> " Paste without autoindent
set mouse=a          " Automatic enable mouse
set textwidth=0
set wrapmargin=0     " Turns off physical line wrapping (automatic insertion of newlines)
set laststatus=2     " Status line always visible (useful with vim-airline)
set wrapscan         " Search next/ Search previous are cyclic.
" set clipboard=autoselect,unnamed,unnamedplus,exclude:cons\|linux  " Clipboard is copied to unnamed register (")
set clipboard+=unnamedplus
set title
set diffopt+=vertical " Gdiff open in vertical.
set splitright
set splitbelow
set timeoutlen=500 " timeoutlen : time to wait for chain character (leader, etc) Default is 1000, 1 sec
set hid            " Send files to buffer instead of closing them -- e,n ... commands.
set wildmode=list:longest,full
"}}}
" Searching {{{
" Search visual selection (problems with end of line ^M character)
vnoremap // y/<C-R>"<CR>
vnoremap s y:%s/<C-R>"/
set gdefault   " avoid to /g at the end of search.
set ignorecase " ignore case
set smartcase  " expcept when there is a case on the query
set hlsearch   " highlight search
set incsearch  " incremental search
"}}}
" Aesthetics {{{
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set scrolloff=20                         " 999 keeps the cursos in the middle.
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
" }}}
" Undofile {{{
set undofile  " Maintain a undofile to keep changes between sessions.
set undodir=~/.vim/undo/
" }}}

" Tabs and whitespaces {{{
set autoindent
set backspace=indent,eol,start
set expandtab
" set matchpairs+=<:>
"}}}
" Indent {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
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
nnoremap <leader>ts "=strftime("%F")<CR>P
inoremap <F8> <C-R>=strftime("%a %d %b %Y")<CR>
" Copy filename to clipboard {{{
  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%:p")<CR>
 " relative path (src/foo.txt)
  nnoremap <leader>cfr :let @+=expand("%")<CR>
  " filename (foo.txt)
  nnoremap <leader>cfl :let @+=expand("%:t")<CR>
  " directory name (/something/src)
  nnoremap <leader>cfd :let @+=expand("%:p:h")<CR>
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
nmap <leader>0 :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
"}}}
" setlocal foldmethod {{{
noremap <leader>ss :setlocal foldmethod=syntax
" }}}
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

function! SetDispatchToCTest()
  call SetNThreads()
  if exists("g:buildFolder")
    let b:dispatch='make test --no-print-directory' . (g:n_threads > 1 ? (' -j'.(g:n_threads)) : '') . ' -C ' . (g:buildFolder)
  else
    call BuildFolderSearch()
    call SetDispatchToCTest()
  endif
endfunction
function! CTestDispatchArgs(args)
  call SetDispatchToCTest()
  let b:dispatch = b:dispatch . ' ARGS=''' . a:args . ''''
" env CTEST_OUTPUT_ON_FAILURE=TRUE
endfunction
com! -nargs=* CTestArgs call DispArg(<q-args>)
"}}}
" BuildFolderAppend(str) {{{
function! BuildFolderAppend(str)
  let g:buildFolder = g:buildFolder . (a:str)
endfunction
"}}}
" end of makeprg functions }}}
" Neomake Setup {{{
  " let g:neomake_open_list   = 2 " Open automatically quick/loc list conserving cursor position. vim-togglelist plugin provides <Leader>q / l to toggle lists.
  let g:neomake_list_height = 6
  hi NeomakeWarningMsg ctermfg=black ctermbg=yellow cterm=bold
  hi NeomakeErrorMsg ctermfg=white ctermbg=red cterm=bold
  let g:neomake_error_sign = {
              \ 'texthl': 'NeomakeErrorMsg',
              \ }
  let g:neomake_warning_sign = {
              \ 'texthl': 'NeomakeWarningMsg',
              \ }
"}}}
" Neomake makers {{{
" Cppcheck
function! SetWarningType(entry)
  if a:entry.type =~? '\m^[SPI]'
    let a:entry.type = 'I'
  endif
endfunction

" local for cpp file.
let g:neomake_cpp_cppcheck_maker = {
        \ 'exe': 'cppcheck',
        \ 'args': ['%:p', '-q', '--enable=style'],
        \ 'errorformat': '[%f:%l]: (%trror) %m,' .
        \ '[%f:%l]: (%tarning) %m,' .
        \ '[%f:%l]: (%ttyle) %m,' .
        \ '[%f:%l]: (%terformance) %m,' .
        \ '[%f:%l]: (%tortability) %m,' .
        \ '[%f:%l]: (%tnformation) %m,' .
        \ '[%f:%l]: (%tnconclusive) %m,' .
        \ '%-G%.%#',
        \ }
        " \ 'postprocess': function('SetWarningType')
" Global for project.
let g:neomake_cppcheck_maker = {
        \ 'exe': 'cppcheck',
        \ 'args': ['%:p', '-q', '--enable=style'],
        \ 'errorformat': '[%f:%l]: (%trror) %m,' .
        \ '[%f:%l]: (%tarning) %m,' .
        \ '[%f:%l]: (%ttyle) %m,' .
        \ '[%f:%l]: (%terformance) %m,' .
        \ '[%f:%l]: (%tortability) %m,' .
        \ '[%f:%l]: (%tnformation) %m,' .
        \ '[%f:%l]: (%tnconclusive) %m,' .
        \ '%-G%.%#',
        \ 'buffer_output': 1 }

        " \ 'postprocess': function('SetWarningType'),
"Vim-grepper Setup {{{
" initialize g:grepper with defaults
let g:grepper = {}
runtime autoload/grepper.vim
" When use -tool=git, search from root directory.
let g:grepper.git =
\ { 'grepprg': 'git grep -nI $* -- `git rev-parse --show-toplevel`' }
nnoremap <leader>g :Grepper -tool git<cr>
nnoremap <leader>G :Grepper -tool ag<cr>
nnoremap <leader>GS :Grepper -tool agSF<cr>
"}}}
function! SetSourceFolder(path)
    let g:sourceFolder=a:path
    " Set neomake (global) cppcheck
    let g:neomake_cppcheck_maker['args'] = [g:sourceFolder, '-q', '--enable=style', '-j3']

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

" com! -nargs=1 -complete=file SourceFolder let g:sourceFolder=<q-args> |
"             \ let g:neomake_cppcheck_maker['args'] = [g:sourceFolder, '-q', '--enable=style', '-j3']

  function! NeomakeCppcheck()
      execute 'echo "NeomakeCppCheck on: "g:sourceFolder " started..."'
      execute 'Neomake! cppcheck'
  endfunction
  au FileType c,cpp nnoremap <silent> <Leader>w :call NeomakeCppcheck()<CR>
" Build
  let g:neomake_build_maker = {
        \ 'exe': 'make',
        \ 'args': ['-j5', '--stop', '--no-print-directory', '-C'],
        \ 'append_file': 0,
        \ 'errorformat': '%f:%l:%c: %m',
        \ 'buffer_output': 1 }
" }}}
" NeomakeBuild functions {{{
  let g:NeomakeBuildOnSave  = 0 " To lunch 'Neomake! build' on save (only cpp,c)
  function! NeomakeBuildErrorFormatClang()
    let g:neomake_build_maker['errorformat'] =
              \ '%-G%f:%s:,' .
              \ '%f:%l:%c: %trror: %m,' .
              \ '%f:%l:%c: %tarning: %m,' .
              \ '%f:%l:%c: %m,'.
              \ '%f:%l: %trror: %m,'.
              \ '%f:%l: %tarning: %m,'.
              \ '%f:%l: %m'
    let g:neomake_build_errorformat = g:neomake_build_maker['errorformat']
  endfunction

  function! NeomakeBuildErrorFormatGCC()
    let g:neomake_build_maker['errorformat'] =
              \ '%-G%f:%s:,' .
              \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
              \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
              \ '%-GIn file included%.%#,' .
              \ '%-G %#from %f:%l\,,' .
              \ '%f:%l:%c: %trror: %m,' .
              \ '%f:%l:%c: %tarning: %m,' .
              \ '%f:%l:%c: %m,' .
              \ '%f:%l: %trror: %m,' .
              \ '%f:%l: %tarning: %m,'.
              \ '%f:%l: %m'
    let g:neomake_build_errorformat = g:neomake_build_maker['errorformat']
  endfunction

  function! NeomakeBuildDefault()
    let g:neomake_build_maker['args'] = [(g:n_threads > 1 ? ('-j'.(g:n_threads)) : ''), '--stop', '--no-print-directory', '-C']
  endfunction

  function! NeomakeBuildSetBuildFolder()
    call NeomakeBuildDefault()
    let g:neomake_build_args = g:neomake_build_maker['args'] + [g:buildFolder]
  endfunction

  function! NeomakeBuildPrepare()
    call SetNThreads()       " Sets g:n_threads
    call BuildFolderSearch() " Sets g:buildFolder // TODO and overrides it, which is bad.
    call NeomakeBuildSetBuildFolder()
  endfunction

  function! NeomakeBuildPrepareClang()
    call NeomakeBuildPrepare()
    call NeomakeBuildErrorFormatClang()
    let g:NeomakeBuildOnSave = 0
  endfunction

  function! NeomakeBuildPrepareGCC()
    call NeomakeBuildPrepare()
    call NeomakeBuildErrorFormatGCC()
    let g:NeomakeBuildOnSave = 0
  endfunction

  function! NeomakeBuildUpdate(file_path_append)
    call NeomakeBuildPrepare()
    call BuildFolderAppend(a:file_path_append)
    call NeomakeBuildSetBuildFolder()
  endfunction

  function! NeomakeBuild()
      execute 'echo "NeomakeBuild started..."'
      execute 'Neomake! build'
  endfunction

  function! ToggleNeomakeBuildOnSave()
    if g:NeomakeBuildOnSave == 1
      let g:NeomakeBuildOnSave = 0
    else
      let g:NeomakeBuildOnSave = 1
    endif
  endfunction

  function! NeomakeAutoBuild()
    if g:NeomakeBuildOnSave == 1
      call NeomakeBuild()
    endif
  endfunction

"}}}
" Make and Neomake maps and autocommands Setup {{{
  let g:DispArg = ''
  fun! DispArg(args)
    let g:DispArg = a:args
  endfunction
  " Hack to have file autocompletion in command line (or in q:)
  com! -nargs=* -complete=file DispArgs call DispArg(<q-args>)
  " nnoremap <silent> <Leader>r :execute 'Dispatch ' . g:DispArg<CR>
  au FileType c,cpp au BufWinEnter * call SetNThreads()
  " Call NeomakeBuild() on save if g:NeomakeBuildOnSave=1
  au FileType c,cpp au BufWritePre * call NeomakeAutoBuild()
  au FileType c,cpp nnoremap <silent> <Leader>nn :call NeomakeBuild()<CR>
  au FileType c,cpp nnoremap <silent> <Leader>e :call NeomakeBuild()<CR>
  au FileType c,cpp nnoremap <silent> <Leader>nt :call ToggleNeomakeBuildOnSave()<CR>
  com! -nargs=1 -complete=file BuildFolder let g:buildFolder=<q-args> | call NeomakeBuildSetBuildFolder()
" }}}
" Useful commands: {{{
" write to open file that requires sudo
" :w !sudo tee %
" :earlier 15m
" }}}

function! CommentsLightBlue()
 execute 'highlight Comment ctermfg=LightBlue guifg=LightBlue' 
endfunction
com! ClearQuickFix call setqflist([])
" vim:foldmethod=marker:foldlevel=2
