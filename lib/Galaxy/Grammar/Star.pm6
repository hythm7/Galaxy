#no precompilation;
#use Grammar::Tracer;

role Galaxy::Grammar::Star {

  token TOP { «<star>» }

  proto token star { * }

  token star:sym<tag>  { <name> <.hyphen> <age> <.hyphen> <core> <.hyphen> <form> <.hyphen> <tag> <ext>? }
  token star:sym<form> { <name> <.hyphen> <age> <.hyphen> <core> <.hyphen> <form> <ext>? }
  token star:sym<core> { <name> <.hyphen> <age> <.hyphen> <core> }
  token star:sym<age>  { <name> <.hyphen> <age> }
  token star:sym<name> { <name> }

  token name { [ <.alnum>+ <!before <dot>> ]+ % <hyphen> }
  token age  { [ [ $<agepart> = [ <.digit>+ | '*' ] ]+ % <dot> ] <plus>? }
  token core { 'x86_64' | 'i386' }
  token form { <.digit>+ }
  token tag  { <.alnum>+ }

  token ext { <.dot> <xyz> }

  token xyz    { 'xyz' }

  token dot    { '.' }
  token plus   { '+' }
  token hyphen { '-' }
}

role Galaxy::Grammar::Star::Actions {

  method TOP ( $/ ) { make $<star>.ast }

  method star:sym<name> ( $/ ) {
    my $name = $<name>.Str;

    make  { :$name }
  }

  method star:sym<age> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;

    make  { :$name, :$age }
  }

  method star:sym<core> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;

    make  { :$name, :$age, :$core }
  }


  method star:sym<form> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;
    my $form = $<form>.Int;

    make  { :$name, :$age, :$core, :$form }
  }

  method star:sym<tag> ( $/ ) {
    my $name = $<name>.Str;
    my $age  = $<age>.ast;
    my $core = $<core>.Str;
    my $form = $<form>.Int;
    my $tag  = $<tag>.Str;

    make  { :$name, :$age, :$core, :$form, :$tag }
  }

  method age ( $/ ) { make Version.new: $/ }

}
