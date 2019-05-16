grammar Galaxy::Grammar::Cnf {

  token TOP { <sections> }

  token sections { <section>* %% <.nl> }

  proto rule section { * }
  rule section:sym<galaxy>    { <.ws> <lt> <sym> <gt> <.nl> <glxlaw>+ % <.nl> }
  rule section:sym<gravity>   { <.ws> <lt> <sym> <gt> <.nl> <grvlaw>+ % <.nl> }
  rule section:sym<blackhole> { <.ws> <lt> <sym> <gt> <.nl> <blklaw>+ % <.nl> }

  proto rule glxlaw { * }
  rule glxlaw:sym<pretty> { <.ws> <sym> }
  rule glxlaw:sym<cool>   { <.ws> <sym> }
  rule glxlaw:sym<yolo>   { <.ws> <sym> }
  rule glxlaw:sym<core>   { <.ws> <sym> <core> }
  rule glxlaw:sym<origin> { <.ws> <sym> <path> }
  rule glxlaw:sym<name>   { <.ws> <sym> \w+ }

  proto rule grvlaw { * }
  rule grvlaw:sym<cluster> { <.ws> <sym> }
  rule grvlaw:sym<origin>  { <.ws> <sym> <path> }

  proto rule blklaw { * }
  rule blklaw:sym<cluster> { <.ws> <sym> }
  rule blklaw:sym<origin>  { <.ws> <sym> <path> }


  proto token core { * }
  token core:sym<x86_64> { <sym> }
  token core:sym<i386>   { <sym> }

  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token lt  { '<' }
  token gt  { '>' }
  token ws  { \h* }
  token nl  { \n+ }
}


class Galaxy::Grammar::Cnf::Actions {
  method TOP ( $/ ) { make $<sections>.ast }

  method sections ( $/ ) { make $<section>».ast.hash }

  method section:sym<galaxy>    ( $/ ) { make ~$<sym> => $<glxlaw>».ast.hash }
  method section:sym<gravity>   ( $/ ) { make ~$<sym> => $<grvlaw>».ast.hash }
  method section:sym<blackhole> ( $/ ) { make ~$<sym> => $<blklaw>».ast.hash }

  method glxlaw:sym<pretty> ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<cool>   ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<yolo>   ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<core>   ( $/ ) { make ~$<sym> => ~$<core> }
  method glxlaw:sym<origin> ( $/ ) { make ~$<sym> => ~$<path> }

  method grvlaw:sym<cluster> ( $/ ) { make ~$<sym> => True }
  method grvlaw:sym<origin> ( $/ )  { make ~$<sym> => $<path>.IO }

  method blklaw:sym<cluster> ( $/ ) { make ~$<sym> => True }
  method blklaw:sym<origin> ( $/ )  { make ~$<sym> => $<path>.IO }
}


