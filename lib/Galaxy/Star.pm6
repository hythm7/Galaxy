use Cro::Uri;
use Galaxy::Planet;

unit class Galaxy::Star;

has Str      $.star is required;
has Str      $.name is required;
has Version  $.age  is required;
has Str      $.core is required;
has Int      $.form is required;
has Str      $.tag  is required;
has          $.chksum;
has          @.cluster;
has          @.law;
has          @.env;
has Cro::Uri $.source;
has Cro::Uri $.location;

has Galaxy::Planet @.planet;

submethod BUILD (

  Str:D :$!star,
  Str:D :$!name,
  Str:D :$age,
  Str:D :$!core,
  Int:D :$!form,
  Str:D :$!tag,
       :$!chksum,
  Str:D :$source,
  Str:D :$location,
        :@planet,
        :@!cluster,
        :@!law,
        :@!env,

  ) {

  $!age      = Version.new: $age;
  $!source   = Cro::Uri.parse: $location;
  $!location = Cro::Uri.parse: $location;
  @!planet.push: Galaxy::Planet.new: |$_ for @planet;
}

method cluster ( ) {
  @!cluster;
}

method gist ( ) {
  $!star;
  #for @!cluster -> %cluster {
     #put '└ ' ~ ( %cluster<name>, %cluster<age> ).join( '-' );
  #}
}
