use Cro::Uri;
use Galaxy::Planet;

unit class Galaxy::Star;

has Str     $.name is required;
has Version $.age  is required;
has Str     $.core is required;
has Int     $.form is required;
has Str     $.tag  is required;
has Str     $.chksum;

has Galaxy::Planet @.planet;
has @!cluster;

has Cro::Uri       $.location;

submethod BUILD (

  :$!name,
  :$age,
  :$!core,
  :$form,
  :$!tag,
  :$!chksum,
  :$location,
  :@planet,

  :@!cluster,

  ) {

  $!age      = Version.new: $age;
  $!form     = $form.Int;
  $!location = Cro::Uri.parse: $location;
  @!planet   = Galaxy::Planet.new: |$_ for @planet;
}

method cluster ( ) {
  @!cluster;
}

method gist ( ) {
  put ( $!name, $!age, $!core, $!form, $!tag ).join( '-' );
  for @!cluster -> %cluster {
     put '└ ' ~ ( %cluster<name>, %cluster<age> ).join( '-' );
  }
}
