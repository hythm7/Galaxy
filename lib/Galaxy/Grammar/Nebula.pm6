#no precompilation;
#use Grammar::Tracer;
use Cro::Uri;

grammar Galaxy::Grammar::Nebula {

  token TOP { <nebulas> }

  token nebulas { <.ws> <nebula>* %% <.nl> }

  rule nebula   { <lt> <hostname> <gt> <.nl> <nbllaw>+ % <.nl> }

  proto rule nbllaw { * }
  rule nbllaw:sym<disable>  { <.ws> <sym> }
  rule nbllaw:sym<location> { <.ws> <sym> <location> }

  proto token location { * }
  token location:sym<uri>  { <uri>  }
  token location:sym<path> { <path> }

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
  method TOP ( $/ ) { make <nebula> => $<nebulas>.ast }

  method nebulas ( $/ ) { make $<nebula>».ast }
  method nebula ( $/ ) { make $<hostname>.Str => $<nbllaw>».ast.hash }

  method nbllaw:sym<disable> ( $/ ) { make ~$<sym> => True }
  method nbllaw:sym<location> ( $/ ) { make ~$<sym> => $<location>.ast }

  method location:sym<path> ( $/ ) { make $<path>.IO }
  method location:sym<uri> ( $/ ) { make Cro::Uri.parse($/.Str) }
}


