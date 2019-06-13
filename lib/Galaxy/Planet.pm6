unit class Galaxy::Planet;

has IO  $.path;
has $.type;
has $.size;
has $.owner;
has $.gid;
has $.mode;

submethod BUILD (

  :$path,
  :$!owner,
  :$!gid,
  :$!type,
  :$!mode,

) {

  $!path = $path.IO;

}
