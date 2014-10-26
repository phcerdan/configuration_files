syn match cppMyExtra "::"
syn match cppMyExtra ";"
hi link cppMyExtra cIncluded

syn match cppMyOperator "&"
syn match cppMyOperator "&&"
syn match cppMyOperator "|"
syn match cppMyOperator "||"
syn match cppMyOperator "->"
syn match cppMyOperator "-="
syn match cppMyOperator "+="
syn match cppMyOperator "*="
syn match cppMyOperator "/="
syn match cppMyOperator "=="
syn match cppMyOperator "!="
syn match cppMyOperator "<="
syn match cppMyOperator ">="
syn match cppMyOperator "<<"
syn match cppMyOperator ">>"
syn match cppMyOperator "*"
syn match cppMyOperator "+"
syn match cppMyOperator "-"
syn match cppMyOperator "--"
syn match cppMyOperator "++"
"Missing single < and >, but I don't want to highlight template brackets.
hi link cppMyOperator cppBoolean
" highlight cppMyOperator cterm=bold gui=bold ctermfg= guifg=goldenrod


