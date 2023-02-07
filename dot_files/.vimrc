set nocompatible
syntax on
let mapleader=" "
" For latex and R plugins
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
" Force vim to load python3 before python2
if has('python3')
endif
" Debuggers: {{{
" Force vertical split on gdb (packadd termedebug, :TermdebugCommand ...)
let g:termdebug_wide = 10
if has('nvim')
  Plug 'mfussenegger/nvim-dap'
  " You need pip install neovim in any virtualenv to Ultisnips to work
  Plug 'mfussenegger/nvim-dap-python'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
endif
" }}}
" Note-taking utilities Plugins  {{{
  Plug 'mrtazz/simplenote.vim'           " Simplenote: https://app.simplenote.com/
  if filereadable(expand("~/.simplenoterc"))
    source ~/.simplenoterc
  endif
  let g:SimplenoteFiletype="markdown"
  let g:SimplenoteNoteFormat="%15N%_%D"
  " let g:SimplenoteVertical=1
  let g:SimplenoteSingleWindow=1
  " Commands to open simplenote specific notes
  command! Todo SimplenoteOpen 0d1d94d49dbc46b780bf86a047da1b65
  command! Projects SimplenoteOpen 4c739a854243b3d7caabddda1340bcbb

  Plug 'freitass/todo.txt-vim' " Todo.txt: https://todotxt.org/

  " Plug 'gu-fan/riv.vim' " reStructuredText (python markdown). I use it as rst syntax/folding rather than note taker.
  Plug 'phcerdan/InstantRst' " reStructuredText preview in browser.
  " Requires pip install https://github.com/gu-fan/instant-rst.py/archive/master.zip
  " My fork modify the option g:instant_rst_slow to only refresh preview on BufWrite
  let g:instant_rst_slow=1
  " Plug 'vimwiki/vimwiki'  " vim-wiki, natural substitute of org-mode in vim.
  " Plug 'vim-scripts/utl.vim'            " Universal Text Linking (for urls and text linking)
  " Plug 'tpope/vim-speeddating'          " Modify dates with C-A, C-X (like integers)
  " Plug 'mattn/calendar-vim'             " Calendar <localleader>cal
  " Plug 'vim-scripts/SyntaxRange'        " Syntax Highlighting in code blocks
" }}}
Plug 'rhysd/committia.vim'              " More pleasant commit layout
Plug 'rhysd/git-messenger.vim'          " Show git commit diff in pop-up window: <Leader>gm
" git-messenger {{{
let g:git_messenger_no_default_mappings=v:true
nmap <Leader>m <Plug>(git-messenger)
" }}}
Plug 'tpope/vim-fugitive'               " Git,G<command>. Gcommit
Plug 'shumphrey/fugitive-gitlab.vim'    " Gbrowse works in gitlab
Plug 'tpope/vim-rhubarb'                " Gbrowse for github.
Plug 'junegunn/gv.vim'                  " :GV for commit browser, GV! for one this file, GV? fills location list.
Plug 'tpope/vim-unimpaired'             " Maps for change buffers, etc using [b ]b etc.
Plug 'jlanzarotta/bufexplorer'          " Show list of buffers with <Leader>be, bs, bv.
Plug 'tpope/vim-surround'

Plug 'tpope/vim-obsession'              " Save sessions :Obsess, Restore: vim -S, or :source . Also used by tmux-resurrect
Plug 'tomtom/tcomment_vim'              " Toggle comment with gcc
Plug 'tpope/vim-sleuth'                 " Automatic detection of indent, based on current file or folder files with same extension.
Plug 'tpope/vim-abolish'                " substitutions with plurals, cases, etc.
Plug 'tpope/vim-repeat'                 " repeat commands(normal mode) with .
Plug 'vim-scripts/visualrepeat'         " works with visual mode too.
Plug 'wsdjeg/vim-fetch'                 " Enable opening files with format: vim file_name.xxx:line,column
Plug 'skywind3000/asyncrun.vim'         " async :! command, read output using error format, or use % raw to ignore.
Plug 'powerman/vim-plugin-AnsiEsc'      " For escaping terminal colors in vim
Plug 'mh21/errormarker.vim'             " errormarker to display errors of asyncrun , https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
" Plug 'phcerdan/ale'                     " my fork with header linting hack (providing .cpp per header)
" Plug 'junegunn/goyo.vim'                " Distraction free. :Goyo
Plug 'mhinz/vim-startify'               " Start screen, and SSave SSLoad for sessions
Plug 'vim-scripts/restore_view.vim'     " Restore file position and FOLDS.
Plug 'yssl/QFEnter'                     " Open items from qf/loc lists in whatever buffer

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

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
" Escape colour characters. Used for google test.
au FileType qf nnoremap <silent> <leader>x :AnsiEsc<CR>
" }}}
" }}}
Plug 'simnalamburt/vim-mundo'           " Navigate undo history.
" nnoremap <F5> :MundoToggle<CR>
Plug 'ntpeters/vim-better-whitespace'   " Highlight whitespaces and provide StripWhiteSpaces()
" Align and Tabularize: {{{
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
" }}}
" File Navigation and Search: {{{
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'

" }}}
" Search/Grep {{{
Plug 'mhinz/vim-grepper' " Modular approach. Default is ag.
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': './install --all' } " Command line (zsh, etc) fuzzy searcher. Better than CtrlP (only unix)
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture' " Add AgRaw and RgRaw when using FZF to pass options to rg and ag

Plug 'majutsushi/tagbar'
" }}}
"Color Schemes and status-line {{{
Plug 'luochen1990/rainbow'
let g:rainbow_active = 0 "set to 0 if you want to enable it later via :RainbowToggle
Plug 'rainux/vim-desert-warm-256'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
" Plug 'justinmk/molokai'
" Include inversion of fg/bg in MatchParen (PR opened upstream)
Plug 'phcerdan/molokai'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'gcmt/taboo.vim'              " Rename tabs
" Plug 'ryanoasis/vim-devicons'      " powerline icons in vim.
"}}}
" TMUX {{{
Plug 'christoomey/vim-tmux-navigator'   " Navigating vim/tmux with same keys. Default keys are <c-hjkl>
let g:tmux_navigator_disable_when_zoomed=1
Plug 'jpalardy/vim-slime'               " Slime (emacs). Send/Copy from vim to other pane
" Plug 'tmux-plugins/vim-tmux-focus-events' " OBSOLETE vim8.2. Allow FocusGained and FocusLost to work in vim running inside tmux. set autoread
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
" Plug 'kana/vim-operator-user' " vim-clang-format dependency to map = (equalprg) to ClangFormat
Plug 'rhysd/vim-clang-format'

Plug 'rhysd/vim-grammarous'
" Python autopep8
Plug 'tell-k/vim-autopep8'
" }}}
" Docs navigation {{{
" Also see Cppman for c++
Plug 'KabbAmine/zeavim.vim'
" }}}
" Tools/Utilities {{{
Plug 'qpkorr/vim-renamer'
" }}}
" neovim telescope {{{
if has('nvim')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-dap.nvim'
endif
" }}}
" chatGPT {{{
" Requires setting env variable OPENAI_API_KEY. Check ~/.secrets
Plug 'MunifTanjim/nui.nvim'
Plug 'jackMort/ChatGPT.nvim'
" }}}
" jupyter
" Language Clients {{{
" Autocompletion common utils {{{
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Enter select. Note: \<C-g>u is used to break undo level.
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
" inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}
" Ale
Plug 'dense-analysis/ale'
" coc : https://github.com/neoclide/coc.nvim {{{
" Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" https://github.com/antoinemadec/coc-fzf. Basically I want references preview
" with FZF style (coc does a double horizontal split which is meh)
Plug 'antoinemadec/coc-fzf'
" Q: CocFzf looks different from my other Fzf commands. How to make it the same?
let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []
" coc extensions {{{
" Install with :CocInstall coc-xxx
" List with :CocList extensions
" coc-ultisnips
" coc-snippets
" coc-json
" coc-css
" coc-tsserver
" coc-prettier
" coc-eslint
" coc-pyright
" coc-xml
" *coc-ccls (in ~/.config/nvim/coc-settings.json
" }}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <c-space> coc#refresh()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> ge <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gs :call CocActionAsync('showSubTypes')<CR>
nmap <silent> gp :call CocActionAsync('showSuperTypes')<CR>
nmap <silent> gh :call CocActionAsync('doHover')<CR>
" Deprecated, use gd instead
nmap <silent> <leader>fd <Plug>(coc-definition)
nmap <silent> <leader>fh :call CocActionAsync('doHover')<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>ga  :<C-u>CocList diagnostics<cr>
" Show commands.
nnoremap <silent><nowait> <leader>gc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>go  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>gs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>gj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>gk  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>gp  :<C-u>CocListResume<CR>


" }}}
" coc-snippets {{{
imap  <leader>dp <Plug>(coc-snippets-expand)
" }}}
" coc-ccls : https://github.com/MaskRay/ccls/wiki/coc.nvim {{{
" Check configuration file in ~/.config/nvim/coc-settings.json
" Cross references extension
" bases
nnoremap <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" bases of up to 3 levels
nnoremap <silent> xB :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
" derived
nnoremap <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" derived of up to 3 levels
nnoremap <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>
" caller
nnoremap <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
" callee
nnoremap <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>
" $ccls/member
" member variables / variables in a namespace
nnoremap <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
" member functions / functions in a namespace
nnoremap <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" nested classes / types in a namespace
nnoremap <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>
nmap <silent> xt <Plug>(coc-type-definition)<cr>
nnoremap <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
nnoremap <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>
nnoremap xx x
" }}} end coc-ccls
" coc-prettier {{{
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" }}} end coc-prettier
" coc-python {{{
au FileType python nnoremap <silent> cr :CocCommand python.execInTerminal<cr>
au FileType python vnoremap <silent> cr :CocCommand python.execSelectionInTerminal<cr>
" }}}
" }}} end coc
" Plug 'jackguo380/vim-lsp-cxx-highlight'  " Use ccls (or clangd) for syntax based highlights
" "     Requires ` "highlight": { "lsRanges" : true } ` in coc-settings.json
" }}} Language Client
" Language Specific Plugins and Settings {{{
" LATEX {{{
Plug 'lervag/vimtex' " Fork from Latex-box. Minimalistic ll to compile, lv to view, xpdf/zathura recommended.
Plug 'brennier/quicktex' " Shortcuts/Abbreviations for latex
"}}}
" R {{{
" Plug 'jalvesaq/Nvim-R' " Includes VimCom functionalities.
" }}}
" Python {{{
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
" If you don't have nodejs and yarn. use pre build Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" If you have nodejs and yarn
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
let g:mkdp_command_for_global = 1
"Plug 'JamshedVesuna/vim-markdown-preview'
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
" jupyter {{{
" jupyter notebook autorefresh notebook
if has('nvim')
  Plug 'kiyoon/jupynium.nvim', { 'do': 'pip3 install --user .' }
  Plug 'rcarriga/nvim-notify' " optional
endif
" }}} Jupyter
" }}} Language Specifics
" AUTOCOMPLETERS {{{
Plug 'SirVer/ultisnips'          " Awesomeness. Create your own snippets
Plug 'honza/vim-snippets'        " Merged cmake changes!
Plug 'github/copilot.vim'        " Copilot (openAI), requires :Copilot setup in each computer
" javascript {{{
" Highlighters: {{{
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty' " like vim-jsx but add indent
Plug 'leafgarland/typescript-vim' "ts files
" }}}
" }}}
" graphql {{{
Plug 'jparise/vim-graphql'
" }}}
" AUTOCOMPLETERS }}}
call plug#end()            " required
" vim-plug END }}}

" Telescope Setup {{{
if has('nvim')
  lua << EOF
  require('telescope').setup()
  require('telescope').load_extension('dap')
EOF
endif
" }}}

" ChatGPT Setup {{{
if has('nvim')
lua << EOF
require('chatgpt').setup()
EOF
endif
" }}}

" nvim-dap Setup {{{
if has('nvim')
lua << EOF
  -- From https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
  require("dapui").setup()
  require("nvim-dap-virtual-text").setup()
  require('dap-python').setup()
  local dap = require('dap')
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed
    name = "lldb"
  }
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      -- program = function()
      --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      -- end,
      program = function()
        return vim.fn.input('Path to executable: ', vim.api.nvim_get_var('buildFolder'), 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = function()
          s = vim.fn.input('Args: ', vim.api.nvim_get_var('debugArgs'), 'file')
          -- Split by whitespaces
          split_args = {}
          for arg in s:gmatch("%S+") do table.insert(split_args, arg) end
          return split_args
      end,
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      runInTerminal = false,
    },
  }
  -- If you want to use this for rust and c, add something like this:
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  local is_windows = function()
      return vim.loop.os_uname().sysname:find("Windows", 1, true) and true
  end
  local current_python = function()
    local venv_path = os.getenv('VIRTUAL_ENV')
    if venv_path then
        if is_windows() then
            return venv_path .. '\\Scripts\\python.exe'
        else
            return venv_path .. '/bin/python'
        end
    else
        return '/usr/bin/python'
    end
  end

  dap.adapters.python = {
    type = 'executable',
    -- command = '/usr/bin/python', -- Assume debugpy is globally installed
    command = current_python(),
    args = {'-m', 'debugpy.adapter'}
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch a file",
      cwd = function()
          return "${workspaceFolder}"
      end,

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = function()
        return vim.fn.input('File to execute: ', "${file}", 'file')
      end,
      pythonPath = function()
        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
        local venv_path = os.getenv('VIRTUAL_ENV')
        if venv_path then
          if is_windows() then
              return venv_path .. '\\Scripts\\python.exe'
          else
              return venv_path .. '/bin/python'
          end
        else
          return '/usr/bin/python'
        end
      end,
      args = function()
          s = vim.fn.input('Args: ', vim.api.nvim_get_var('debugArgs'), 'file')
          -- Split by whitespaces
          split_args = {}
          for arg in s:gmatch("%S+") do table.insert(split_args, arg) end
          return split_args
      end,
    },
  }
EOF

  nnoremap <silent> <F4> :lua require('dapui').toggle()<CR>
  nnoremap <silent> <F5> :lua require('dap').continue()<CR>
  nnoremap <silent> <F6> :lua require('dap').up()<CR>
  nnoremap <silent> <S-F6> :lua require('dap').down()<CR>
  nnoremap <silent> <F7> :lua require('dap').run_to_cursor()<CR>
  nnoremap <silent> <F9> :lua require('dap').toggle_breakpoint()<CR>
  nnoremap <silent> <F10> :lua require('dap').step_over()<CR>
  nnoremap <silent> <F11> :lua require('dap').step_into()<CR>
  nnoremap <silent> <S-F11> :lua require('dap').step_out()<CR>

  nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
  nnoremap <silent> <leader>ds :lua require'dap'.step_over()<CR>
  nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>j
  nnoremap <silent> <leader>do :lua require'dap'.step_out()<CR>
  nnoremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
  nnoremap <silent> <leader>dB :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  nnoremap <silent> <leader>dp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
  nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
  nnoremap <silent> <leader>dt :lua require'dap'.run_to_cursor()<CR>

  nnoremap <silent> <leader>dk :lua require'dap'.up()<CR>
  nnoremap <silent> <leader>dj :lua require'dap'.down()<CR>

  nnoremap <silent> <leader>dh :lua require'dap.ui.widgets'.hover()<CR>
  vnoremap <silent> <leader>dh :lua require'dap.ui.variables'.visual_hover()<CR>
  nnoremap <silent> <leader>de :lua require'dap'.set_exception_breakpoints({"all"})<CR>
  autocmd FileType dap-float nnoremap <buffer><silent> q <cmd>close!<CR>
endif
" }}}

" nvim-treesitter Setup {{{
if has('nvim')
  lua << EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "cpp", "python", "javascript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    auto_install = true,
    highlight = {
      enable = false,              -- false will disable the whole extension
      -- disable = { "c", "rust" },  -- list of language that will be disabled
    },
    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "gnn",
        scope_incremental = "gns",
        node_decremental = "gnm",
      },
    },
    indent = {
      enable = false
    }
  }
EOF
endif
" " Folding {{{
"   set foldmethod=expr
"   set foldlevel=99
"   set foldexpr=nvim_treesitter#foldexpr()
" else
  " set nofoldenable      " disable folding. Slow, even with fastfold plug
  " Folding is slow, but useful.
  " From wiki: http://vim.wikia.com/wiki/All_folds_open_when_open_a_file
  " These options aims to disable it when opening a new buffer.
  " Use zM and zR to fold/unfold. zA toggle
  set foldlevel=99
  set foldlevelstart=99
  set foldmethod=syntax
" }}}

" terminal Setup {{{
" Default is 10000, maximum is 100000, set to max
let scrollback = 100000
" }}}

" emmet setup {{{
" Default <C-Y> is too far away. Use :Maps to see mappings. <C-Z>, to expand
let g:user_emmet_leader_key='<C-Z>'
" }}}

" startify {{{
  let g:startify_bookmarks = [ {'c': '~/.vimrc'} ]
" }}}
" commitia Setup {{{
  " Open commitia if COMMIT buffer
  let g:committia_open_only_vim_starting = 0
  " Use single column always
  let g:committia_use_singlecolumn = 'always'
" }}}
" Fugitive and vim-rhubarb, fugitive-gitlab Setup {{{
  set tags^=./.git/tags;
  nnoremap <Leader>gs :Gstatus<CR>
  let g:fugitive_git_executable = 'hub'
  let g:fugitive_gitlab_domains = ['https://gitlab.kitware.com']
" }}}

" restore_view Setup{{{
  set viewoptions=cursor,folds,slash,unix
" }}}

" Zoom windows {{{
" From: https://stackoverflow.com/questions/13194428/is-better-way-to-zoom-windows-in-vim-than-zoomwin
" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <Leader>z :ZoomToggle<CR>
"}}}

" Easy-Align Setup {{{
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
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

" Ack/Ag/Rg Setup {{{
  if executable('rg')
    " let g:ackprg = 'ag --vimgrep --smart-case'
    " cnoreabbrev Ag Ack
    " Use rg over Grep
    set grepprg=rg\ --vimgrep
    " nnoremap <silent> <Leader>/ :execute 'Ack ' . input('Ack/')<CR>
  endif
"}}}

" fzf Setup {{{
" let g:fzf_layout = { 'down': '~40%' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.4, 'yoffset': 0.9, 'xoffset': 0.5, } }
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
" let g:fzf_command_prefix = 'F'
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

" fzf: Delete selected buffers {{{
function! Bufs()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': Bufs(),
  \ 'sink*': { lines -> execute('bwipeout '.join(map(lines, {_, line -> split(line)[0]}))) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

"}}}

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
" vim-agriculture{{{
command! -nargs=0 Todos AgRaw '(TODO|XXX|FIXME)'
let g:agriculture#rg_options = '--column --line-number --no-heading --fixed-strings --smart-case --hidden --follow --glob "!.git/*" --color=always'
" }}}

" advanced RG fzf {{{
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
" }}}

" Rgc uses Rg in current buffer directory!
command! -bang -nargs=* Rgc call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --smart-case --hidden --follow --glob "!.git/*" --color=always '.(<q-args>).' '.expand("%:h"), 1, { 'options': '--bind=ctrl-e:select-all,ctrl-d:deselect-all' }, <bang>0)
command! -nargs=* GAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), g:fzf_layout))
" Specialized for ITK.
let g:ITKFolder = '~/Software/ITK/src-ITK-master'
function! s:with_itk_git_root()
  let root = systemlist('git -C '. g:ITKFolder . ' rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
command! -nargs=* IAg
  \ call fzf#vim#ag(<q-args>, extend(s:with_itk_git_root(), g:fzf_layout))
command! -nargs=* IFiles
  \ call fzf#vim#files(<q-args>, extend(s:with_itk_git_root(), g:fzf_layout))
" Map C-p to override CtrlP plugin.
nnoremap <silent> <C-p> :exe 'Files ' . <SID>fzf_root()<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>bB :Windows<CR>
nnoremap <silent> <Leader>; :Commands<CR>
nnoremap <silent> <Leader>fhl :Helptags<CR>
nnoremap <silent> <Leader>fl :BLines<CR>
nnoremap <silent> <Leader>fL :Lines<CR>
nnoremap <silent> <Leader>w :call SearchWord()<CR>
" vnoremap <silent> K :call SearchWordVisualSelection()<CR>
nnoremap <silent> <Leader>ft :BTags<CR>
nnoremap <silent> <Leader>fT :Tags<CR>
nnoremap <silent> <Leader>gl :Commits<CR>
nnoremap <silent> <Leader>ga :BCommits<CR>
" History Search
nnoremap <silent> <Leader>gs :History/<CR>
" History Commands
nnoremap <silent> <Leader>gc :History:<CR>
" History Files
nnoremap <silent> <Leader>gf :History:<CR>

command! -bang -nargs=* PAg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)


" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir PFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


function! SearchWord()
  let grep_command = 'Rg'
  execute grep_command expand('<cword>')
endfunction

function! SearchWordVisualSelection() range
  let grep_command = 'Rg'
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute grep_command selection
endfunction

" Open all files in qlist: https://github.com/junegunn/fzf.vim/issues/40
function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction
command! QuickFixOpenAll call QuickFixOpenAll()
" }}}

" context.vim setup {{{
  " " Really laggy, only update on CursorHold
  " let g:context_add_autocmds = 0
  " autocmd CursorHold   * call context#update('CursorHold')
  " autocmd VimResized   * call context#update('VimResized')
  " autocmd User GitGutter call context#update('GitGutter')
" }}}

" Tagbar Setup {{{
  nnoremap <silent> <Leader>bb :TagbarToggle<CR>
  nnoremap <silent> <Leader>bp :TagbarTogglePause<CR>
  let g:tagbar_sort=0 " Keep order of file.
  " updatetime is a general vim option (default 4000), too low and glitches happens
  set updatetime=300 " Control the time to update highlight of the closest tag to current cursor position.
  function! TagbarPauseAndStopAutoUpdate()
    execute 'TagbarTogglePause'
    call tagbar#StopAutoUpdate()
  endfunction
" }}}

" Jellybeans setup{{{
  let g:jellybeans_use_term_italics = 1
  " let g:jellybeans_use_lowcolor_black = 0
" }}}

" Lightline Setup {{{
set showtabline=2
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'

let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \   'asyncrun_status': 'LightlineAsyncrunstatus',
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel',
      \ },
      \ 'component': {
      \   'lineinfo': '%3l:%-2v%<',
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum' ],
      \   'inactive': [ 'tabnum' ],
      \ },
      \ 'tabline': {
      \   'left': [['buffers']],
      \   'right': [['asyncrun_status', 'tabs']]
      \ },
      \ }

let g:lightline.mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ }
" only show buffer name in lightline-bufferline (no path)
let g:lightline#bufferline#filename_modifier = ':t'

function! LightlineAsyncrunstatus()
  return ['%{g:asyncrun_status}']
endfunction

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

" Update with coc
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
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

" Tmuxline Setup {{{
  let g:tmuxline_powerline_separators = 1
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

" vim-clang-format Setup {{{
let g:clang_format#detect_style_file=1 " Auto detect .clang-format file.
let g:clang_format#enable_fallback_style=0 " Does nothing if .clang-format is not found
" When the value is 1, formatexpr option is set by vim-clang-format
" automatically in C, C++ and ObjC codes.
" Vim's format mappings (e.g. gq) get to use clang-format to format.
" This option is not comptabile with Vim's textwidth feature.
" You must set textwidth to 0 when the formatexpr is set.
" let g:clang_format#auto_formatexpr=1 " BUGGY, creates extra indent...?
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>x :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>x :ClangFormat<CR>
" }}}
"
" vim-autopep8 Setup {{{
autocmd FileType python nnoremap <buffer><Leader>x :call Autopep8()<CR>
autocmd FileType python vnoremap <buffer><Leader>x :call Autopep8()<CR>
" 88 is Black style, why not
let g:autopep8_max_line_length=88
" let b:autopep8_on_save = 1

" }}}

" vim-grammarous Setup {{{
  let g:grammarous#disabled_rules = {
        \ 'tex' : ['WHITESPACE_RULE', 'EN_QUOTES', 'COMMA_PARENTHESIS_WHITESPACE', 'CURRENCY', 'EN_UNPAIRED_BRACKETS'],
        \ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
        \ }
  let g:grammarous#show_first_error = 1
  nmap <localleader>. <Plug>(grammarous-open-info-window)
" }}}

" Languages SETUP {{{
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
    if executable('nvr')
      let g:vimtex_compiler_progname = 'nvr'
    else
      echoerr 'Please install nvr (neovim-remote)'
    endif
  endif
  " Workaround for buggy behaviour where quicktex thinks we are in math mode.
  function! QuickTexDisableMathMode()
    let g:quicktex_math=g:quicktex_tex
  endfunction
  command! QuickTexDisableMathMode call QuickTexDisableMathMode()

  set thesaurus+=~/.vim/thesaurus_moby.txt
  let g:vimtex_fold_enabled=0 " Need to use fastFold with this option or... really slow.
  let g:vimtex_fold_manual=1 " autofold is slow in vim, use FastFold instead of this option!.
  let g:vimtex_compiler_latexmk = {
        \ 'continuous' : 1,
        \}
  let g:vimtex_quickfix_autojump=0
  let g:vimtex_quickfix_open_on_warning=0
  " zathura forwarding require: xdotool but xdotool fails in arch (wayland?)
  " let g:vimtex_view_method = 'zathura'
  " let g:vimtex_view_general_viewer = 'mupdf'
  " For Okular {{{
  let g:vimtex_view_general_viewer = 'okular'
  " Forward:
  let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
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
" nmap <leader>z <Plug>Zeavim
" vmap <leader>z <Plug>ZVVisSelection
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
    " let g:python_host_prog  = '/usr/bin/python2'
    " let g:python3_host_prog = '/usr/bin/python3'
  endif
" To run current file.
au FileType python nnoremap <buffer> <Leader>e :exec '!python' shellescape(@%, 1)<cr>
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
autocmd Filetype gitcommit setlocal spell
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
autocmd Filetype markdown setlocal spell
" au FileType markdown setlocal conceallevel=0
au FileType json setlocal conceallevel=0
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
" autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>
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
" Languages SETUP }}}

" UltiSnips Setup {{{
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsSnippetDir='~/.vim/UltiSnips'
  let g:UltiSnipsSnippetDirectories=['UltiSnips',"plug/vim-snippets/UltiSnips"]
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
  let g:UltiSnipsListSnippets="<F3>"
  function! OpenSnippets()
	execute 'edit ~/.vim/plugged/vim-snippets/snippets/' . &filetype . '.snippets'
  endfunction

"General Completer Options {{{
" don't give |ins-completion-menu| messages.  For example,
" -- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c

" }}}
" CompleterParameter Setup {{{

  " inoremap <silent><expr> ( complete_parameter#pre_complete("()")
  " let g:complete_parameter_use_ultisnips_mapping = 1
" }}}

" Neovim options {{{
if has('nvim')
  set inccommand=split
endif
" }}}
" COLOUR OPTIONS: {{{
" set t_Co=256
" colorscheme desert256
" colorscheme desert-warm-256
" molokai {
" colorscheme molokai
" let g:molokai_original=1
" let g:rehash256=1
" }
" colorscheme jellybeans
if has('termguicolors') " Truecolor. modern vim or nvim only.
  set termguicolors
  " vim only: RGB colors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set background=dark
" gruvbox-material {{{
" let g:gruvbox_material_better_performance = 1
" let g:gruvbox_material_palette = 'original'
" let g:gruvbox_material_enable_italic = 1
" let g:gruvbox_material_enable_bold = 1
" colorscheme gruvbox-material
" }}}
" gruvbox {{{
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
" }}}
" monokai-tasy {{{
  " let g:vim_monokai_tasty_italic = 1
  " colorscheme vim-monokai-tasty
" }}}
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif
"}}}
" SYNTAX {{{
syntax spell toplevel
syntax enable
set synmaxcol=400 " syntax highlight is really slow for monstruously long lines.
setlocal spell spelllang=en_us
set nospell
au FileType c,cpp setlocal spell
" map <F12> :setlocal spell! spelllang=en_us<CR>
" hi stuff must be after syntax (not colour)
" hi ColorColumn ctermbg=DarkGray guibg=#2c2d27
au FileType c,cpp setlocal colorcolumn=81
" hi CursorLine cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>cl :set cursorline!<CR>

if version >= 702
  autocmd BufWinLeave * call clearmatches() " Solve performance problems with multiple syntax match.
endif
"}}}

" Basic {{{
set number           " Show line numbers
" set autochdir        " Set cd to current file directory. Mess with plugins
command! Cdc cd %:p:h
set pastetoggle=<F2> " Paste without autoindent
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
" Hit '%' on 'if' to jump to 'else'.
runtime macros/matchit.vim
set autoread
" Rely on undo instead
" set noswapfile
"Turn on backup option
set backup
" Where to store backups, the folder must be created beforehand
" It does not work, ~/.config/nvim/backup, but not sure why
set backupdir=~/tmp/nvim/backup
"Make backup before overwriting the current buffer
set writebackup
"Overwrite the original backup file
set backupcopy=yes
set backupext=.bak
" Undofile {{{
set undofile  " Maintain a undofile to keep changes between sessions.
set undodir=~/.vim/undo/
" }}}

"
"}}}
" Render options (for Slow machines) {{{
" set relativenumber " In relative way (SLOW rendering!!!!!) :((
set lazyredraw
" }}}
" Indent {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Indent commands {{{
command! Indent2 set tabstop=2 | set shiftwidth=2 | set softtabstop=2 | set expandtab
command! Indent4 set tabstop=4 | set shiftwidth=4 | set softtabstop=4 | set expandtab
command! Indent8 set tabstop=8 | set shiftwidth=8 | set softtabstop=8 | set expandtab
command! Indent2L setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal softtabstop=2 | setlocal expandtab
command! Indent4L setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal expandtab
command! Indent8L setlocal tabstop=8 | setlocal shiftwidth=8 | setlocal softtabstop=8 | setlocal expandtab
command! IndentITK execute 'Indent2' | set cinoptions={1s,:0,l1,g0,c0,(0,(s,m1 | call SetClangFormatITK()
" Indent commands }}}
" Indent }}}
" Utils/Buffers {{{
" Workaround to avoid setting autochdir:
" typing zc in command mode expand to e current_directory.
cnoremap zc e <c-r>=expand("%:h")<cr>/
" <Leader><Enter> in quickfix to open a vertical split.
" autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L
" }}}
" Searching {{{
set gdefault   " avoid to /g at the end of search.
set ignorecase " ignore case
set smartcase  " except when there is a case on the query
set hlsearch   " highlight search
set incsearch  " incremental search
"}}}
" Aesthetics {{{
set list
set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set scrolloff=20                         " 999 keeps the cursos in the middle.
" Autocomplete window: show preview win, show menu with 1 match, insert longest match
" set completeopt=preview,menuone,longest,noselect
" set completeopt+=noselect
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
" Tabs and whitespaces {{{
set autoindent
set backspace=indent,eol,start
" set matchpairs+=<:>
"}}}
" Taken from https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc?fileviewer=file-view-default {{{
" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"
" Don't move when pressing * (highlight current word)
" Also use g* instead of *, to avoid searching for whole words.
" This is usefult when using the register "/, to avoid re-using 
" whole words brackets \<, \>
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
nnoremap <silent> g* :let stay_star_view = winsaveview()<cr>g*:call winrestview(stay_star_view)<cr>
" Use H to move to the beginning of the line. h moves one, H moves big.
nnoremap H ^
" Use L to move to the end of the line. l moves one, L moves big.
nnoremap L g_
" Populate the quicklist with the hits of the word over the cursor for just the current file.
command! GREP :execute 'normal *' | :execute 'vimgrep /'.expand('<cword>').'/j '.expand('%') | :copen | :wincmd p
nnoremap <leader>/ :GREP<CR>
" Highlight Word {{{
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Uses b marker
    " Save our location.
    normal! mb
    " Yank the current word into the b register.
    normal! "byiw
    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n
    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)
    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@b, '\') . '\>'
    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)
    " Move back to our original location.
    normal! `b
endfunction " }}}

" Mappings {{{
nnoremap <silent> <leader>hh :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>h1 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>h2 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>h3 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>h4 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>h5 :call HiInterestingWord(6)<cr>
" }}}

" Default Highlights {{{
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
" }}}
noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>
" }}}
" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>
" }}}
" }}}

" General Maps: {{{
" Insert White Space in normal mode with s space
" nnoremap s<space> i<space><esc> # Use a<space> instead, this blocks lightspeed
" Search visual selection (problems with end of line ^M character)
vnoremap // y/<C-R>"<CR>
vnoremap S y:%S/<C-R>"/
" Escape remap (Ctrl-C doesnt work well in some plugins) (not reliable)
noremap <C-c> <Esc>
au FileType fzf noremap <C-c> <C-C>
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
" inoremap <F8> <C-R>=strftime("%a %d %b %Y")<CR>
" Copy filename to clipboard {{{
  function! CopyAbsolutePath()
    " absolute path (/something/src/foo.txt)
    let @+=expand("%:p")
  endfunction

  function! CopyRelativePath()
   " relative path (src/foo.txt)
    let @+=expand("%")
  endfunction

  function! CopyFilename()
    " filename (foo.txt)
    let @+=expand("%:t")
  endfunction

  function! CopyDirectoryPath()
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
":term maps {{{
if has("nvim")
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au FileType fzf tunmap <buffer> <Esc>
endif
"}}}

" Return to last edit position when opening files (You want this!) Obsolete: plugin:restore_view does this. {{{
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
function! TestFolderAppend(str)
  let g:testFolder = g:testFolder . (a:str)
endfunction
"}}}
" end of makeprg functions }}}

"Vim-grepper Setup {{{
" initialize g:grepper with defaults
let g:grepper = {}
runtime autoload/grepper.vim
" When use -tool=git, search from root directory.
let g:grepper.git =
\ { 'grepprg': 'git grep -nI $* -- `git rev-parse --show-toplevel`' }
nnoremap <leader>GG :Grepper -tool git<cr>
nnoremap <leader>GS :Grepper -tool rgSF<cr>
"}}}
" Cppcheck WarningType {{{
function! SetWarningType(entry)
  if a:entry.type =~? '\m^[SPI]'
    let a:entry.type = 'I'
  endif
endfunction
" }}}

" SourceFolder {{{
function! SetSourceFolder(path)
    let g:sourceFolder=a:path
    " Set vim-grepper {{{
    if !has_key(g:grepper, 'tools')
      let g:grepper.tools = []
    endif
    " Rg
    if index(g:grepper.tools,'rgSF') == -1
      let g:grepper.tools = g:grepper.tools + ['rgSF']
    endif
    let g:grepper.rgSF = g:grepper.rg
    let g:grepper.rgSF =
          \ { 'grepprg': 'rg --vimgrep $* ' . g:sourceFolder }
    execute 'command! -nargs=+ -complete=file GrepSF'
          \ 'Grepper -noprompt -tool rgSF -query <args>'
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
    execute 'command! -nargs=+ -complete=file GrepGitSF'
          \ 'Grepper -noprompt -tool gitSF -query <args>'
    " }}}
endfunction
com! -nargs=1 -complete=file SourceFolder call SetSourceFolder(<q-args>)
" }}}

" asyncrun setup {{{
" ring the bell to notify you job finished
" let g:asyncrun_bell = 1
" automatically open quickfix window when AsyncRun command is executed
" the number is the number of lines height.
let g:asyncrun_open = 10
" For using it with errorformat (display errors)
let g:asyncrun_auto = "make"
" augroup QuickfixStatus
" 	au! BufWinEnter quickfix setlocal
" 		\ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
" augroup END
let g:asyncrun_trim = 1 " trim empty lines
" better quickfix toogle:
" noremap <F9> :call asyncrun#quickfix_toggle(8)<cr>
let g:toggle_list_copen_command="call asyncrun#quickfix_toggle(8)"
" vim-fugive (using Make) async, from: https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
com! ClearErrorSigns execute "sign unplace * buffer=" . bufnr("%")
" }}}

" Linters {{{
" Ale {{{
" Disabled by default
let g:ale_enabled = 0
" Disable lsp (use coc instead)
let g:ale_disable_lsp = 1
" (optional, for completion performance) run linters only when I save files
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
" run it when exiting insert
let g:ale_lint_on_insert_leave = 1
" show loclist vertical
" let g:ale_list_vertical = 1
      " \ 'cpp': ['clangtidyheader'],
let g:ale_linters = {
      \ 'cpp': ['clangtidy'],
      \ 'python':['flake8']
      \}
let g:ale_cpp_cquery_cache_directory='/home/phc/tmp/cquery_cache'
" \ 'javascript': ['eslint'],
let g:ale_fixers = {
\   'python': [
\           'flake8'
\   ],
\}
let g:ale_python_autopep8_options = '--aggressive'
" flake8 {{{
" E302: comment/lines (expected 2 lines...)
let g:ale_python_flake8_options='--ignore E302 --max-line-length=120'
"}}}
" clangtidy {{{
" Disable specific projects checks. default: = ['']
" Other option is to enable only checks that you are interested, but we might
" miss new checkers added in the future.
let g:ale_cpp_clangtidy_checks = [
      \ 'bugprone-*',
      \ '-bugprone-exception-escape*',
      \ 'misc-*',
      \ '-misc-non-private-member-variables-in-classes*',
      \ 'clang-analyzer-*',
      \ 'modernize-*',
      \ '-modernize-use-trailing-return-type*',
      \ '-modernize-avoid-c-arrays*',
      \ 'performance-*',
      \ 'portability-*',
      \ 'readability-*',
      \ '-readability-magic-numbers*',
      \ '-readability-qualified-auto*',
      \ '-readability-isolate-declaration*',
      \ ]
      " cplusplus static analyzer are slow
      " \ 'cppcoreguidelines-*',
      " \ 'clang-analyzer-*',
      " \ '-android-*',
      " \ '-boost-*',
      " \ '-fuchsia-*',
      " \ '-google-*',
      " \ '-llvm-*',
      " \ '-objc-',
let g:ale_cpp_clangtidyheader_checks = g:ale_cpp_clangtidy_checks
com! -nargs=1 -complete=file HeaderSource let g:ale_cpp_clangtidyheader_sourcefile=<q-args> | let b:ale_cpp_clangtidyheader_sourcefile=<q-args>
" let g:ale_pattern_options = {
"       \   '\.h$': {
"       \       'ale_linters': {'cpp': ['clangtidy']},
"       \       'ale_cpp_clangtidy_options': '~/repository_local/FFT-from-image-compute-radial-intensity/src/apps/RadialIntensity/test/test_saxs_sim_functional.cpp',
"       \   },
"       \}
" }}} end of tidy
" }}} end of ale
" }}} end of linters
" Build functions {{{
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
  function! ErrorFormatJavascriptJest()
    " From https://github.com/craigdallimore/vim-jest-cli/blob/master/compiler/jest-cli.vim
    let efmt = '%.%#\ at\ %f:%l:%c,%.%#\ at\ %.%#(%f:%l:%c)'
    return efmt
  endfunction

  augroup FileType javascript
    let &errorformat=ErrorFormatJavascriptJest()
  augroup end
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
    let lst = 'ninja -C ' . g:buildFolder
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
  " au FileType c,cpp au BufWinEnter * call SetNThreads()
  " Call NeomakeBuild() on save if g:BuildOnSave=1

  nnoremap <silent> <Leader>n :execute "AsyncRun! " . NinjaString()<CR> <bar> let g:bCommand = 'ninja'<CR>
  au FileType c,cpp nnoremap <silent> <Leader>e :execute "AsyncRun! " . MakeString()<CR> <bar> let g:bCommand = 'make'<CR>
  au FileType c,cpp nnoremap <silent> <Leader>nt :call ToggleBuildOnSave()<CR>
  com! -nargs=1 -complete=file BuildFolder let g:buildFolder=fnamemodify(<q-args>, ':p') <bar> let g:testFolder=fnamemodify(<q-args>, ':p')
  com! -nargs=1 -complete=file TestFolder let g:testFolder=<q-args>
  com! -nargs=1 BuildTarget let g:buildTarget=<q-args>
  com! -nargs=1 DockerBuild let g:dockerBuild=<q-args>
  com! -nargs=1 TestArgs let g:testArgs=<q-args>
  com! -nargs=* -complete=file DebugArgs let g:debugArgs=<q-args>
  nnoremap <silent> <Leader>r :execute "AsyncRun! (cd " . g:testFolder . "; ctest " . g:testArgs . ")"<CR>
  " TODO, refactor strings to variables for reusability/avoid repetition
  " Compile with ninja and run the test, requires buildFolder and testArgs defined
  nnoremap <silent> <Leader>c :execute "AsyncRun! " . NinjaString() . " && (cd " . g:testFolder . "; ctest " . g:testArgs . ")"<CR>
  nnoremap <silent> <Leader>nd :execute "AsyncRun! " . g:dockerBuild<CR>

  au User TermdebugStartPre echomsg "Changing cwd for the gdb terminal to g:testFolder " . g:testFolder | let g:oldcwd=getcwd() | execute "cd " . g:testFolder
  " au User TermdebugStopPre  echomsg 'debugging starting'
  au User TermdebugStopPre echomsg "Changing cwd back to source code: " . g:oldcwd | execute "cd " . g:oldcwd

" }}}
" End Build functions }}}
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
com! -nargs=? Task exec "!task " . <q-args>
com! Tasklog exec "!cat ~/tasks.log | tail -n 10"
com! Taskecho exec "!cat ~/tasks | tail -n 10"
com! Tasknext exec "!task | head -n 1"
com! -nargs=1 Taskfinish exec "!task -f <q-args>"
com! Taskedit exec "e ~/tasks"
com! Tasklogedit exec "e ~/tasks.log"
com! Taskhelp echo g:Taskhelp_string
let g:Taskhelp_string="# Simple todo list manager.\n
            \# Tasks will be written to ~/tasks.\n
            \# Finished tasks, plus a timestamp, will be written to ~/tasks.log.\n
            \#\n
            \# usage: task [-e] [-f [line]]\n
            \#\n
            \#   task        list tasks\n
            \#   task ...    add task\n
            \#   task -e     edit tasks using $EDITOR\n
            \#   task -f 3   finish task on line 3\n
            \#   task 3      finish task on line 3\n
            \#   task -f     finish all tasks"
" }}}

" Other {{{
function! CommentsLightBlue()
 execute 'highlight Comment ctermfg=LightBlue guifg=LightBlue'
endfunction
com! ClearQuickFix call setqflist([])
" }}}

" Defx {{{
call defx#custom#column('filename', {
            \ 'directory_icon': '⯈',
            \ 'opened_icon': '⯆',
            \ })
" Git
let g:defx_git#indicators = {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ }
let g:defx_git#column_length = 1
let g:defx_git#show_ignored = 0
let g:defx_git#raw_mode = 0
" Icons
let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 2
let g:defx_icons_directory_icon = ''
let g:defx_icons_mark_icon = '*'
let g:defx_icons_parent_icon = ''
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = ''
" Options below are applicable only when using "tree" feature
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''

nnoremap <leader>nn :Defx -split=vertical -winwidth=35 -direction=topleft -columns=git:indent:icons:filename:type -toggle -search=`expand('%:p')` `getcwd()`<CR>
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
                \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> c
                \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
                \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
                \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
                \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> E
                \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
                \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
                \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> O
                \ defx#do_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
                \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
                \ defx#do_action('toggle_columns',
                \                'mark:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
                \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
                \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
                \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
                \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
                \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
                \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
                \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
                \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
                \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-r>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
                \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
                \ defx#do_action('change_vim_cwd')
    " Mouse
    nnoremap <silent><buffer><expr> <2-LeftMouse>
                \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> <3-LeftMouse>
                \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> <RightMouse>
                \ defx#do_action('cd', ['..'])
endfunction
" }}}

" vim:foldmethod=marker:foldlevel=0
