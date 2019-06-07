#no precompilation;
#use Grammar::Tracer::Compact;

use Galaxy::Grammar::Star;
use Galaxy::Grammar::Cmd::PSixy;

grammar Galaxy::Grammar::Cmd {
  also is Galaxy::Grammar::Star;
  also does Galaxy::Grammar::Cmd::PSixy;

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

  token galaxy    { <?> }

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
  also is Galaxy::Grammar::Star::Actions;

  method TOP:sym<galaxy> ( $/ ) {
    my %law;

    %law<cmd>          = <galaxy>;
    %law<galaxy>       = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<galaxy><star> = $<stars>.ast        if $<stars>;

    make %law;
  }

  method TOP:sym<gravity> ( $/ ) {
    my %law;

    %law<cmd>           = <gravity>;
    %law<galaxy>        = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<gravity>       = $<grvlaw>».ast.hash if $<grvlaw>;
    %law<gravity><star> = $<stars>.ast;

    make %law;
  }

  method TOP:sym<blackhole> ( $/ ) {
    my %law;

    %law<cmd>             = <blackhole>;
    %law<galaxy>          = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<blackhole>       = $<blklaw>».ast.hash if $<blklaw>;
    %law<blackhole><star> = $<stars>.ast;

    make %law;
  }

  method TOP:sym<star> ( $/ ) {
    my %law;

    %law<cmd>        = <star>;
    %law<galaxy>     = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<star>       = $<star>».ast.hash   if $<strlaw>;
    %law<star><star> = $<stars>.ast;

    make %law;
  }

  method TOP:sym<planet> ( $/ ) {
    my %law;

    %law<cmd>            = <planet>;
    %law<galaxy>         = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<planet>         = $<star>».ast.hash   if $<strlaw>;
    %law<planet><planet> = $<path>.IO;

    make %law;
  }

  method TOP:sym<spacetime> ( $/ ) {
    my %law;

    %law<cmd>              = <spacetime>;
    %law<galaxy>           = $<glxlaw>».ast.hash if $<glxlaw>;
    %law<spacetime>        = $<star>».ast.hash   if $<strlaw>;
    %law<spacetime><event> = $<event>.Str;

    make %law;
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


