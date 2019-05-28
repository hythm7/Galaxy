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
    my $resp = await $!nebula.get: $url;
    my @candi = await $resp.body;
    @candi;
  }

}


has Source @.source;

submethod BUILD ( :@source ) {

  @!source.push: Source.new: |$_ for @source;

}

method locate ( Str :$name!, Version :$age, Str :$core, Int :$form, Str :$tag ) {

  my @url;

  @url.push: 'star';
  @url.push: $name;
  @url.push: $age   if $age;
  @url.push: $core  if $core;
  @url.push: $form  if $form;
  @url.push: $tag   if $tag;

  my @candi = @!source.hyper.map( *.get: url => @url.join('/') ).flat.unique(:with(&[eqv]));

  @candi;
}
