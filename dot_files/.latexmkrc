# support for the glossaries package:
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
sub makeglossaries {
   my ($base_name, $path) = fileparse( $_[0] );
   pushd $path;
   my $return = system "makeglossaries $base_name";
   popd;
   return $return;
}

$pdflatex = 'pdflatex -synctex=1 --shell-escape %O %S';
$out_dir = 'output';
# $pdflatex = 'lualatex --interaction=nonstopmode --synctex=1 --shell-escape %O %S';
