#no precompilation;
#use Grammar::Tracer;

use Galaxy::Grammar::Star;
use Galaxy::Grammar::Cmd::Cool;

grammar Galaxy::Grammar::Cmd {
  also does Galaxy::Grammar::Cmd::Cool;
  also does Galaxy::Grammar::Star;

  proto rule TOP { * }

  rule TOP:sym<gravity>   { <glxlaw>* <gravity>   <grvlaw>* <stars>  }
  rule TOP:sym<blackhole> { <glxlaw>* <blackhole> <blklaw>* <stars>  }
  rule TOP:sym<spacetime> { <glxlaw>* <spacetime> <sptlaw>* <event>  }
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
  token blklaw:sym<cluster> { «<cluster>» }


  proto rule pltlaw { * }
  proto rule strlaw { * }
  proto rule sptlaw { * }


  proto token core { * }
  token core:sym<x86_64> { <sym> }
  token core:sym<i386>   { <sym> }


  token path { <[ a..z A..Z 0..9 \-_.!~*'():@&=+$,/ ]>+ }

  token galaxy    { «'galaxy'»    | <?> }

  proto token gravity { * }
	token gravity:sym<gravity>   { «<sym>» }

  proto token blackhole { * }
	token blackhole:sym<blackhole>   { «<sym>» }

  proto token spacetime { * }
	token blackhole:sym<spacetime>   { «<sym>» }

  proto token star { * }
	token star:sym<star>   { «<sym>» }

  proto token planet { * }
	token planet:sym<planet>   { «<sym>» }

  proto token origin { * }
  token origin:sym<origin> { <sym> }

  proto token cluster { * }
  token cluster:sym<cluster> { <sym> }

  proto token pretty { * }
  token pretty:sym<pretty>  { <sym> }

  proto token yolo { * }
  token yolo:sym<yolo>  { <sym> }

  token stars { [ <starname>+ % <.blank> ] }

  token hostname { (\w+) ( <dot> \w+ )* }
  token event { 'event' }

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

    %laws<cmd>           = <galaxy>;
    %laws<galaxy>        = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<galaxy><stars> = $<stars>.ast        if $<stars>;

    make %laws;
  }

  method TOP:sym<gravity> ( $/ ) {
    my %laws;

    %laws<cmd>            = <gravity>;
    %laws<galaxy>         = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<gravity>        = $<grvlaw>».ast.hash if $<grvlaw>;
    %laws<gravity><stars> = $<stars>.ast;

    make %laws;
  }

  method TOP:sym<blackhole> ( $/ ) {
    my %laws;

    %laws<cmd>              = <blackhole>;
    %laws<galaxy>           = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<blackhole>        = $<blklaw>».ast.hash if $<blklaw>;
    %laws<blackhole><stars> = $<stars>.ast;

    make %laws;
  }

  method TOP:sym<star> ( $/ ) {
    my %laws;

    %laws<cmd>         = <star>;
    %laws<galaxy>      = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<star>        = $<star>».ast.hash   if $<strlaw>;
    %laws<star><stars> = $<stars>.ast;

    make %laws;
  }

  method TOP:sym<planet> ( $/ ) {
    my %laws;

    %laws<cmd>            = <planet>;
    %laws<galaxy>         = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<planet>         = $<star>».ast.hash   if $<strlaw>;
    %laws<planet><planet> = $<path>.IO;

    make %laws;
  }

  method TOP:sym<spacetime> ( $/ ) {
    my %laws;

    %laws<cmd>              = <spacetime>;
    %laws<galaxy>           = $<glxlaw>».ast.hash if $<glxlaw>;
    %laws<spacetime>        = $<star>».ast.hash   if $<strlaw>;
    %laws<spacetime><event> = $<event>.Str;

    make %laws;
  }


  method stars ( $/ ) { make $<starname>».ast }

  method glxlaw:sym<yolo>    ( $/ ) { make <yolo>    => True }
  method glxlaw:sym<origin>  ( $/ ) { make <origin>  => $<path>.IO }
  method glxlaw:sym<pretty>  ( $/ ) { make <pretty>  => True }
  method glxlaw:sym<cool>    ( $/ ) { make <cool>    => True }
  method glxlaw:sym<core>    ( $/ ) { make <core>    => $<core>.Str }

  method grvlaw:sym<cluster> ( $/ ) { make <cluster> => True }
  method grvlaw:sym<origin>  ( $/ ) { make <origin>  => $<path>.IO }
}


