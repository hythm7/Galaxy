#no precompilation;
#use Grammar::Tracer;

use Galaxy::Grammar::Star;

grammar Galaxy::Grammar::Cmd {
  also does Galaxy::Grammar::Star;

  proto rule TOP { * }

  rule TOP:sym<gravity>   { <gravity>   <grvlaw>*        }
  rule TOP:sym<blackhole> { <blackhole> <blklaw>*        }
  rule TOP:sym<spacetime> { <spacetime> <sptlaw>*        }
  rule TOP:sym<star>      { <star>      <strlaw>*        }
  rule TOP:sym<planet>    { <planet>    <pltlaw>* <path> }
  rule TOP:sym<galaxy>    { <galaxy>    <glxlaw>*        }


  proto rule glxlaw { * }

  rule glxlaw:sym<pretty> { «<sym>» }
  rule glxlaw:sym<cool>   { «<sym>» }
  rule glxlaw:sym<yolo>   { «<sym>» }

  rule glxlaw:sym<core>   { «<sym> <core>»     }
  rule glxlaw:sym<origin> { «<sym> <path>»     }
  rule glxlaw:sym<name>   { «<sym> <hostname>» }


  proto rule grvlaw { * }

  rule grvlaw:sym<origin>  { «<sym> <path>» }
  rule grvlaw:sym<cluster> { «<sym>» }


  proto rule blklaw { * }

  token blklaw:sym<origin>  { «<sym> <path>» }
  token blklaw:sym<cluster> { «<sym>» }


  proto rule pltlaw { * }


  proto token core { * }

  token core:sym<x86_64> { <sym> }
  token core:sym<i386>   { <sym> }

  token hostname { (\w+) ( <dot> \w+ )* }

  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token galaxy    { «'galaxy'»    | <?> }
	token gravity   { «'gravity'»   | «'g'» }
	token blackhole { «'blackhole'» | «'b'» }
	token spacetime { «'spacetime'» | «'t'» }
	token star      { «'star'»      | «'s'» }
	token planet    { «'planet'»    | «'p'» }

  token lt  { '<' }
  token gt  { '>' }
  token dot { '.' }

  token ws { \h* }
  token nl { \n+ }
}


class Galaxy::Grammar::Cmd::Actions {
  also does Galaxy::Grammar::Star::Actions;

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


