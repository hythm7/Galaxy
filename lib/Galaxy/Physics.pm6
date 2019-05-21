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

  submethod BUILD ( ) {

    my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;

    $!origin = $cmd<galaxy><origin> // '/'.IO;
    $!bulge  = $!origin.add: 'etc/galaxy/';
    $!halo   = $!origin.add: 'var/galaxy/';
    $!disk   = $!halo.add:   'galaxy.db';


    my $lawfile    = $!origin.add: 'etc/galaxy/law';
    my $nebulafile  = $!origin.add: 'etc/galaxy/nebula';

    # now law file? generate one!
    my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawfile, actions => Galaxy::Grammar::Cnf::Actions).ast;
    my $nbl = Galaxy::Grammar::Nebula.parsefile($nebulafile, actions => Galaxy::Grammar::Nebula::Actions).ast;

    %!law   = $cnf.merge: $cmd.merge: $nbl;

    $!name   = %!law<galaxy><name>   // chomp qx<hostname>;
    $!core   = %!law<galaxy><core>   // chomp qx<uname -m>;
    $!yolo   = %!law<galaxy><yolo>   // False;
    $!cool   = %!law<galaxy><cool>   // False;
    $!pretty = %!law<galaxy><pretty> // False;

    given %!law<cmd> {

      self.galaxy(    |%!law<galaxy>    ) when 'galaxy';
      self.star(      |%!law<star>      ) when 'star';
      self.planet(    |%!law<planet>    ) when 'planet';
      self.gravity(   |%!law<gravity>   ) when 'gravity';
      self.blackhole( |%!law<blackhole> ) when 'blackhole';
      self.spacetime( |%!law<spacetime> ) when 'spacetime';

    }

  }
