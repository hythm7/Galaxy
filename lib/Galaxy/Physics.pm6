use Hash::Merge::Augment;
use Galaxy::Grammar::Cmd;
use Galaxy::Grammar::Cnf;

unit role Galaxy::Physics;

  has %.laws;

  has Str       $!name;
  has Str       $!core;
  has IO        $!origin;
  has IO        $!disk;
  has IO        $!bulge;
  has IO        $!halo;
  has Bool      $!yolo;
  has Bool      $!cool;
  has Bool      $!pretty;
  # has Nebula    $!nebula;
  # has Gravity   $!gravity;
  # has Blackhole $!blackhole;
  # has Star      $!stars;

  submethod BUILD ( ) {

    my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;

    $!origin = $cmd<galaxy><origin> // '/'.IO;
    $!bulge  = $!origin.add: 'etc/galaxy/';
    $!halo   = $!origin.add: 'var/galaxy/';
    $!disk   = $!halo.add:   'galaxy.db';


    my $lawsfile = $!origin.add: 'etc/galaxy/laws';

    # now laws file? generate one!
    my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawsfile, actions => Galaxy::Grammar::Cnf::Actions).ast;

    %!laws = $cnf.merge: $cmd;

    $!name   = %!laws<galaxy><name>   // chomp qx<hostname>;
    $!core   = %!laws<galaxy><core>   // chomp qx<uname -m>;
    $!yolo   = %!laws<galaxy><yolo>   // False;
    $!cool   = %!laws<galaxy><cool>   // False;
    $!pretty = %!laws<galaxy><pretty> // False;

    say %!laws<gravity>;

    given %!laws<cmd> {

      self.galaxy(    |%!laws<galaxy>    ) when 'galaxy';
      self.star(      |%!laws<star>      ) when 'star';
      self.planet(    |%!laws<planet>    ) when 'planet';
      self.gravity(   |%!laws<gravity>   ) when 'gravity';
      self.blackhole( |%!laws<blackhole> ) when 'blackhole';
      self.spacetime( |%!laws<spacetime> ) when 'spacetime';

    }

  }
