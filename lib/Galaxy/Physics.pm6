use DB::SQLite;
use Hash::Merge::Augment;
use Galaxy::Grammar::Cmd;
use Galaxy::Grammar::Cnf;
use Galaxy::Grammar::Nebula;

unit role Galaxy::Physics;

has %.law;

has Str       $!name;
has Str       $!core;
has IO        $!origin;
has IO        $!disk;
has IO        $!bulge;
has IO        $!halo;
has Bool      $!yolo;
has Bool      $!cool;
has Bool      $!pretty;

has $!db;

submethod BUILD ( ) {

  my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, :actions(Galaxy::Grammar::Cmd::Actions)).ast;

  $!origin = $cmd<galaxy><origin> // '/'.IO;
  $!bulge  = $!origin.add: 'etc/galaxy/';
  $!halo   = $!origin.add: 'var/galaxy/';
  $!disk   = $!halo.add:   'galaxy.db';

  $!db  = DB::SQLite.new: filename => $!disk.Str;

  self!init-db;

  my $lawfile = $!origin.add: 'etc/galaxy/law';
  my $nblfile = $!origin.add: 'etc/galaxy/nebula';

  # now law file? generate one!
  my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawfile, :actions(Galaxy::Grammar::Cnf::Actions)).ast;
  my $nbl = Galaxy::Grammar::Nebula.parsefile($nblfile, :actions(Galaxy::Grammar::Nebula::Actions)).ast;

  %!law   = $cnf.merge: $cmd.merge: $nbl;

  $!name   = %!law<galaxy><name>   // chomp qx<hostname>;
  $!core   = %!law<galaxy><core>   // chomp qx<uname -m>;
  $!yolo   = %!law<galaxy><yolo>   // False;
  $!cool   = %!law<galaxy><cool>   // False;
  $!pretty = %!law<galaxy><pretty> // False;

}

method !init-db ( ) {
  $!db.execute: q:to /SQL/;
    drop table if exists star
    SQL
  $!db.execute: q:to /SQL/;
    drop table if exists planet
    SQL
  $!db.execute: q:to /SQL/;
    drop table if exists cluster
    SQL

  $!db.execute: q:to /SQL/;
    create table if not exists star (
      name     text,
      age      text,
      core     text,
      form     int,
      tag      text,
      location text,
      chksum   text
    )
    SQL

  $!db.execute: q:to /SQL/;
    create table if not exists planet (
      star  text,
      path  text,
      owner int,
      gid   int,
      type  text,
      mode  int
    )
    SQL


  $!db.execute: q:to /SQL/;
    create table if not exists cluster (
      star  text,
      name  text,
      age   text,
      form  int,
      tag   text
    )
    SQL

  my @star = (

    ( 'galaxy', '0.0.1', 'x86_64', 0, 'glx', 'http://localhost/', '' ),
    ( 'rakudo', '0.0.1', 'x86_64', 0, 'glx', 'http://localhost/', '' ),
    ( 'timo',   '0.0.1', 'x86_64', 0, 'glx', 'http://localhost/', '' ),
    ( 'nimo',   '0.0.1', 'x86_64', 0, 'glx', 'http://localhost/', '' ),

  );

  my @planet = (

    ( 'galaxy', '/etc/galaxy',           0, 0, 'd', 644 ),
    ( 'galaxy', '/etc/galaxy/laws',      0, 0, 'f', 644 ),
    ( 'galaxy', '/etc/galaxy/nebula',    0, 0, 'f', 644 ),
    ( 'galaxy', '/etc/galaxy/nebula',    0, 0, 'f', 644 ),
    ( 'galaxy', '/var/galaxy/',          0, 0, 'd', 644 ),
    ( 'galaxy', '/var/galaxy/galaxy.db', 0, 0, 'd', 644 ),

  );


  my @cluster = (

    ( 'timo', 'galaxy', '0.0.1+', '', '' ),
    ( 'timo', 'perl6',  '0.0.1+', '', '' ),
    ( 'nimo', 'perl6',  '0.0.1+', '', '' ),

  );

  $!db.query: 'insert into star    values ( ?, ?, ?, ?, ?, ?, ? )', |$_ for @star;
  $!db.query: 'insert into planet  values ( ?, ?, ?, ?, ?, ? )',    |$_ for @planet;
  $!db.query: 'insert into cluster values ( ?, ?, ?, ?, ? )',       |$_ for @cluster;


}
