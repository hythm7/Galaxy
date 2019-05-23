#no precompilation;
#use Grammar::Tracer;
use Cro::Uri;

grammar Galaxy::Grammar::Nebula {


  token TOP { <.ws> <nebula>* %% <.nl> }

  rule nebula   { <lt> <hostname> <gt> <.nl> <nbllaw>+ % <.nl> }

  proto rule nbllaw { * }
  rule nbllaw:sym<disabled>  { <.ws> <sym> }
  rule nbllaw:sym<location> { <.ws> <sym> <uri> }

  token uri { <alpha>+ <colon> <slash> <slash> <hostname> [ <colon> <digit>+ ]? <slash>? <path>? }

  token hostname { (\w+) ( <dot> \w+ )* }
  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token nl { [ <comment>? \h* \n ]+ }

  token comment { \h* '#' \N* }

  token colon { ':' }
  token slash { '/' }

  token lt  { '<' }
  token gt  { '>' }
  token dot { '.' }
  token ws  { \h* }
}


class Galaxy::Grammar::Nebula::Actions {
  method TOP ( $/ ) { make <nebula> => $<nebula>».ast }

  method nebula ( $/ ) {
    my %nebula = $<nbllaw>».ast.hash;

    %nebula<name> = $<hostname>.Str;

    make %nebula;
  }

  method nbllaw:sym<disabled> ( $/ )  { make $<sym> => True }
  method nbllaw:sym<location> ( $/ ) { make $<sym> => Cro::Uri.parse($<uri>.Str) }

  method location:sym<path> ( $/ ) { make $<path>.IO }
  method location:sym<uri> ( $/ ) { make Cro::Uri.parse($/.Str) }
}


