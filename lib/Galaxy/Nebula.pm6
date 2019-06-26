use Cro::Uri;
use Cro::HTTP::Client;

unit class Galaxy::Nebula;

my class Source {

  has Str               $.name;
  has Bool              $.disabled;
  has Cro::Uri          $.location;
  has Cro::HTTP::Client $.nebula;

  method TWEAK ( ) {
    $!nebula = Cro::HTTP::Client.new: base-uri => $!location, :json;
  }

  method get ( :$url! ) {
    my $resp  = await $!nebula.get: $url;
    my @candi = flat await $resp.body;
    @candi;
  }

}


has Source @.source;

submethod BUILD ( :@source ) {

  @!source.push: Source.new: |$_ for @source;

}

method locate ( Str :$name!, :$age, :$core, :$form, :$tag ) {

  my @url;

  @url.push: 'meta';
  @url.push: $name;
  @url.push: $age   if defined $age;
  @url.push: $core  if defined $core;
  @url.push: $form  if defined $form;
  @url.push: $tag   if defined $tag;

  #my @candi = @!source.hyper.map( *.get: url => @url.join('/') ).flat.unique(:with(&[eqv]));
  my @candi = @!source.grep( not *.disabled ).hyper.map(
    *.get: url => @url.join('/')).flat.sort( &latest ).squish( with => &[eqv] );

  @candi;
}

sub latest ( %a, %b ) {

  Version.new(%b<age>) <=> Version.new(%a<age>) or %b<form> <=> %a<form>;

}
