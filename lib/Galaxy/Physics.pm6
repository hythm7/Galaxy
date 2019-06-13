use DB::SQLite;
use Hash::Merge::Augment;
use Galaxy::Disk;
use Galaxy::Grammar::Cmd;
use Galaxy::Grammar::Cnf;
use Galaxy::Grammar::Nebula;

unit role Galaxy::Physics;

has %.law;

has Str  $!name;
has Str  $!core;
has IO   $!origin;
has IO   $!bulge;
has IO   $!halo;
has Bool $!yolo;
has Bool $!cool;
has Bool $!pretty;

has Galaxy::Disk $!disk;

submethod BUILD ( ) {

  my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;

  $!origin = $cmd<galaxy><origin> // '/'.IO;
  $!bulge  = $!origin.add: 'etc/galaxy/';
  $!halo   = $!origin.add: 'var/galaxy/';

  $!disk   = Galaxy::Disk.new: disk => $!halo.add: 'galaxy.disk';

  my $lawfile = $!origin.add: 'etc/galaxy/law';
  my $nblfile = $!origin.add: 'etc/galaxy/nebula';

  # now law file? generate one!
  my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawfile, actions => Galaxy::Grammar::Cnf::Actions).ast;
  my $nbl = Galaxy::Grammar::Nebula.parsefile($nblfile,  actions => Galaxy::Grammar::Nebula::Actions).ast;

  %!law   = $cnf.merge: $cmd.merge: $nbl;

  $!name   = %!law<galaxy><name>   // chomp qx<hostname>;
  $!core   = %!law<galaxy><core>   // chomp qx<uname -m>;
  $!yolo   = %!law<galaxy><yolo>   // False;
  $!cool   = %!law<galaxy><cool>   // False;
  $!pretty = %!law<galaxy><pretty> // False;

}

