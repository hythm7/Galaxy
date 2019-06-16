use Cro::Uri;
use Galaxy::Planet;

unit class Galaxy::Star;

has Str      $.star is required;
has Str      $.name is required;
has Version  $.age  is required;
has Str      $.core is required;
has Int      $.form is required;
has Str      $.tag  is required;
has IO       $.origin;
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
  Str   :$origin,
        :@planet,
        :@!cluster,
        :@!law,
        :@!env,

  ) {

  $!origin   = $origin.IO;
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

multi method ACCEPTS ( %star --> Bool:D ) {

  my %cluster = @!cluster.first({ .<name> ~~ %star<name> }).hash;

  return False unless Version.new( %star<age> )  ~~ Version.new( %cluster<age> // '' );
  #  return False unless %star<core> ~~ %cluster<core>;
  #  return False unless %star<form> ~~ %cluster<form>;
  #  return False unless %star<tag>  ~~ %cluster<tag>;

  return True;

}
