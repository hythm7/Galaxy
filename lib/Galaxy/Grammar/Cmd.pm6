#no precompilation;
#use Grammar::Tracer;

use Galaxy::Grammar::Star;

grammar Galaxy::Grammar::Cmd {
  also does Galaxy::Grammar::Star;

  proto rule TOP { * }

  rule TOP:sym<gravity>   { <glxlaw>* <gravity>   <grvlaw>* <stars>  }
  rule TOP:sym<blackhole> { <glxlaw>* <blackhole> <blklaw>* <stars>  }
  rule TOP:sym<spacetime> { <glxlaw>* <spacetime> <sptlaw>*          }
  rule TOP:sym<star>      { <glxlaw>* <star>      <strlaw>* <stars>  }
  rule TOP:sym<planet>    { <glxlaw>* <planet>    <pltlaw>* <path>   }
  rule TOP:sym<galaxy>    { <galaxy>  <glxlaw>*   <stars>? }


  proto rule glxlaw { * }
  rule glxlaw:sym<pretty> { «<sym>» }
  rule glxlaw:sym<cool>   { «<sym>» }
  rule glxlaw:sym<yolo>   { «<yolo>» }
  rule glxlaw:sym<core>   { «<sym> <core>»     }
  rule glxlaw:sym<origin> { «<origin> <path>»     }
  rule glxlaw:sym<name>   { «<sym> <hostname>» }


  proto rule grvlaw { * }
  rule grvlaw:sym<origin>  { «<origin> <path>» }
  rule grvlaw:sym<cluster> { «<cluster>» }


  proto rule blklaw { * }
  token blklaw:sym<origin>  { «<origin> <path>» }
  token blklaw:sym<cluster> { «<cluster>» }


  proto rule pltlaw { * }
  proto rule strlaw { * }
  proto rule sptlaw { * }


  proto token core { * }
  token core:sym<x86_64> { <sym> }
  token core:sym<i386>   { <sym> }

  token hostname { (\w+) ( <dot> \w+ )* }

  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token galaxy    { «'galaxy'»    | <?> }
	token gravity   { «'gravity'»   | «'g'» }
	token blackhole { «'blackhole'» | «'b'» }
	token spacetime { «'spacetime'» | «'t'» | «'⏲'» }
	token star      { «'star'»      | «'s'» | «''» }
	token planet    { «'planet'»    | «'p'» }

  token origin  { 'origin'  | 'o' }
  token cluster { 'cluster' | 'c' }

  token pretty  { 'pretty'  | 'p' | '‽' }
  token yolo    { 'yolo'    | 'y' | '✓' }

  token stars { [ <starname>+ % <.blank> ] }

  token lt  { '<' }
  token gt  { '>' }
  token dot { '.' }

  token ws { \h* }
  token nl { \n+ }
}


class Galaxy::Grammar::Cmd::Actions {
  also does Galaxy::Grammar::Star::Actions;

  # has %.law;

  method TOP:sym<galaxy> ( $/ ) {
    my %laws;

    %laws<cmd>    = <galaxy>;
    %laws<stars>  = $<stars>.ast        if $<stars>;
    %laws<galaxy> = $<glxlaw>».ast.hash if $<glxlaw>;

    make %laws;
  }

  method TOP:sym<gravity> ( $/ ) {
    my %laws;

    %laws<cmd>     = <gravity>;
    %laws<stars>   = $<stars>.ast;
    %laws<galaxy>  = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<gravity> = $<grvlaw>».ast.hash if $<grvlaw>;

    make %laws;
  }

  method TOP:sym<blackhole> ( $/ ) {
    my %laws;

    %laws<cmd>       = <blackhole>;
    %laws<stars>     = $<stars>.ast;
    %laws<galaxy>    = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<blackhole> = $<blklaw>».ast.hash if $<blklaw>;

    make %laws;
  }

  method TOP:sym<star> ( $/ ) {
    my %laws;

    %laws<cmd>    = <star>;
    %laws<stars>  = $<stars>.ast;
    %laws<galaxy> = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<star>   = $<star>».ast.hash   if $<strlaw>;

    make %laws;
  }



  #method TOP:sym<spacetime> ( $/ ) { make <spacetime> => $<sptlaw>».ast.hash }
  #method TOP:sym<star>      ( $/ ) { make <star>      => $<strlaw>».ast.hash }
  #method TOP:sym<planet>    ( $/ ) { make <planet>    => $<pltlaw>».ast.hash }

  method stars ( $/ ) { make $<starname>».ast }

  method glxlaw:sym<yolo>   ( $/ ) { make <yolo>     => True }
  method glxlaw:sym<origin> ( $/ ) { make <origin>   => $<path>.IO }
  method glxlaw:sym<pretty> ( $/ ) { make $<sym>.Str => True }
  method glxlaw:sym<cool>   ( $/ ) { make $<sym>.Str => True }
  method glxlaw:sym<core>   ( $/ ) { make $<sym>.Str => $<core>.Str }

  method grvlaw:sym<cluster> ( $/ ) { make <cluster> => True }
  method grvlaw:sym<origin>  ( $/ ) { make <origin>  => $<path>.IO }
}


