unit class Galaxy::Planet;

has IO  $.path;
has Int $.owner;
has Int $.gid;
has Str $.type;
has Int $.mode;

submethod BUILD (

  :$path,
  :$!owner,
  :$!gid,
  :$!type,
  :$!mode,

) {

  $!path = $path.IO;

}
