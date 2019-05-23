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

method locate ( Str :$name!, Version :$age = Version.new, Str :$core = 'x86_64', Int :$form, Str :$tag ) {

  my $url = 'cand?core=x86_64&name=' ~ $name;
  my @candi = @!source.hyper.map( *.get: :$url ).flat.unique(:with(&[eqv]));

  @candi;
}
