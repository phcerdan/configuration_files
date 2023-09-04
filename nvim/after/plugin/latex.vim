" For latex and R plugins
let maplocalleader=";"

let g:vimtex_fold_enabled=0 " Need to use fastFold with this option or... really slow.
let g:vimtex_fold_manual=1 " autofold is slow in vim, use FastFold instead of this option!.
let g:vimtex_compiler_latexmk = {
      \ 'continuous' : 1,
      \}
let g:vimtex_quickfix_autojump=0
let g:vimtex_quickfix_open_on_warning=0

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

" }}}
