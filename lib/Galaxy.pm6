use Galaxy::Grammar::Cmd;
use Galaxy::Grammar::Cnf;

unit class Galaxy:ver<0.0.1>;

  has Str       $.name;
  has Str       $.core;
  has IO        $.origin;
  has IO        $.disk;
  has IO        $.bulge;
  has IO        $.halo;
  has Bool      $.yolo;
  has Bool      $.cool;
  has Bool      $.pretty;
  # has Nebula    $!nebula;
  # has Gravity   $!gravity;
  # has Blackhole $!blackhole;
  # has Star      $!stars;

  method new ( ) {
    my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;


    my $origin   = $cmd<origin> // '/'.IO;

    my $bulge    = $origin.add: '/etc/galaxy';
    my $halo     = $origin.add: '/var/galaxy';

    my $lawsfile = $bulge.add: 'laws';
    my $disk     = $halo.add:  '/galaxy.db';

    # now laws file? generate one!
    my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawsfile, actions => Galaxy::Grammar::Cnf::Actions).ast;



    my %laws = $cnf;
    my $name = %laws<galaxy><name> // chomp qx<hostname>;

    self.bless: |%laws<galaxy>;
  }

  #submethod BUILD (
  #  :$!name    = chomp qx<hostname>;
  #  :$!core    = chomp qx<uname -m>;
  #  :$!origin  = </>.IO;
  #  :$!bulge   = $!origin.add(</etc/galaxy>.IO).cleanup;
  #  :$!halo    = $!origin.add(</var/galaxy>.IO).cleanup;
  #  :$!disk    = $!halo.add(</galaxy.db>.IO).cleanup;
  #  :$!yolo    = False;
  #  :$!cool    = False;
  #  :$!pretty  = False;
  #  :$!gravity;
  #  #:$!blackhole;
  #  :$!nebula;
	#  ) {

  #  $!db        = self!db;
	#	%!stars     = self!local-stars;   #Revist

  #  
	#}
