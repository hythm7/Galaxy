#no precompilation;
#use Grammar::Tracer;

role Galaxy::Grammar::Star {

  token TOP { <starname> }

  proto token starname { * }

  token starname:sym<tag>  { <name> <.hyphen> <age> <.hyphen> <core> <.hyphen> <form> <.hyphen> <tag> <ext>? }
  token starname:sym<form> { <name> <.hyphen> <age> <.hyphen> <core> <.hyphen> <form> <ext>? }
  token starname:sym<core> { <name> <.hyphen> <age> <.hyphen> <core> }
  token starname:sym<age>  { <name> <.hyphen> <age> }
  token starname:sym<name> { <name> }

  token name { [ [ <.alnum>+ <asterisk>? <!before <dot>> ]+ % <hyphen> ] }
  token age  { [ [ <.digit>+ | '*' ]+ % <dot> ] <plus>? }
  token core { 'x86_64' | 'i386' }
  token form { <.digit>+ }
  token tag  { <.alnum>+ }

  token ext { <.dot> <xyz> }

  token xyz    { 'xyz' }

  token dot      { '.' }
  token plus     { '+' }
  token hyphen   { '-' }
  token asterisk { '*' }
}

role Galaxy::Grammar::Star::Actions {

  method TOP ( $/ ) { make $<starname>.ast }

  method starname:sym<name> ( $/ ) {
    my $name = $<name>.Str;

    make  { :$name }
  }

  method starname:sym<age> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;

    make  { :$name, :$age }
  }

  method starname:sym<core> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;

    make  { :$name, :$age, :$core }
  }


  method starname:sym<form> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;
    my $form = $<form>.Int;

    make  { :$name, :$age, :$core, :$form }
  }

  method starname:sym<tag> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;
    my $form = $<form>.Int;
    my $tag  = $<tag>.Str;

    make  { :$name, :$age, :$core, :$form, :$tag }
  }

  method age ( $/ ) { make Version.new: $/ }

}
