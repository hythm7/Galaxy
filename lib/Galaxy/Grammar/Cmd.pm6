#no precompilation;
#use Grammar::Tracer;

grammar Galaxy::Grammar::Cmd {

  proto rule TOP { * }
  rule TOP:sym<gravity>   { <.ws> <gravity>   <grvlaw>* % <.ws> }
  rule TOP:sym<blackhole> { <.ws> <blackhole> <blklaw>* % <.ws> }
  #rule TOP:sym<spacetime> { <.ws> <spacetime> <sptlaw>* % <.ws> }
  rule TOP:sym<star>      { <.ws> <star>      <strlaw>* % <.ws> }
  rule TOP:sym<planet>    { <.ws> <planet>    <pltlaw>* % <.ws> 'etc' }
  rule TOP:sym<galaxy>    { <.ws> <galaxy>    <glxlaw>* % <.ws> }

  proto rule glxlaw { * }
  rule glxlaw:sym<pretty> { <.ws> <sym> }
  rule glxlaw:sym<cool>   { <.ws> <sym> }
  rule glxlaw:sym<yolo>   { <.ws> <sym> }
  rule glxlaw:sym<core>   { <.ws> <sym> <core> }
  rule glxlaw:sym<origin> { <.ws> <sym> <path> }
  rule glxlaw:sym<name>   { <.ws> <sym> \w+ }

  proto rule grvlaw { * }
  rule grvlaw:sym<origin>  { <.ws> <sym> <path> }
  rule grvlaw:sym<cluster> { <.ws> <sym> }

  proto rule blklaw { * }
  token blklaw:sym<origin>  { <.ws> <sym> <path> }
  token blklaw:sym<cluster> { <.ws> <sym> }

  proto rule pltlaw { * }
  proto token core { * }
  token core:sym<x86_64> { <sym> }
  token core:sym<i386>   { <sym> }

  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token galaxy    { 'galaxy'    | <?> }
	token gravity   { 'gravity'   | 'g' }
	token blackhole { 'blackhole' | 'b' }
	token spacetime { 'spacetime' | 't' }
	token star      { 'star'      | 's' }
	token planet    { 'planet'    | 'p' }

  token lt  { '<' }
  token gt  { '>' }
  token ws  { \h* }
  token nl  { \n+ }
}


class Galaxy::Grammar::Cmd::Actions {

  method TOP:sym<galaxy>    ( $/ ) { make <galaxy>    => $<glxlaw>».ast.hash }
  method TOP:sym<gravity>   ( $/ ) { make <gravity>   => $<grvlaw>».ast.hash }
  method TOP:sym<blackhole> ( $/ ) { make <blackhole> => $<blklaw>».ast.hash }
  method TOP:sym<spacetime> ( $/ ) { make <spacetime> => $<sptlaw>».ast.hash }
  method TOP:sym<star>      ( $/ ) { make <star>      => $<strlaw>».ast.hash }
  method TOP:sym<planet>    ( $/ ) { make <planet>    => $<pltlaw>».ast.hash }

  method glxlaw:sym<pretty> ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<cool>   ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<yolo>   ( $/ ) { make ~$<sym> => True }
  method glxlaw:sym<core>   ( $/ ) { make ~$<sym> => ~$<core> }
  method glxlaw:sym<origin> ( $/ ) { make ~$<sym> => ~$<path> }

  method grvlaw:sym<cluster> ( $/ ) { make ~$<sym> => True }
  method grvlaw:sym<origin> ( $/ )  { make ~$<sym> => $<path>.IO }
}


