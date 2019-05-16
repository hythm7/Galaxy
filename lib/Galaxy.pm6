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

    use Hash::Merge::Augment;
    my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;
    my $origin   = $cmd<galaxy><origin> // '/'.IO;
    my $lawsfile = $origin.add: '/etc/galaxy/laws';

    # now laws file? generate one!
    my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawsfile, actions => Galaxy::Grammar::Cnf::Actions).ast;

    my %laws = $cnf.merge: $cmd;

    my %galaxy    = %laws<galaxy>;
    my %gravity   = %laws<gravity>;
    my %blackhole = %laws<blackhole>;


    self.bless: :%galaxy, :%gravity, :%blackhole;
  }

  submethod BUILD ( :%galaxy, :%gravity, :%blackhole ) {

    $!origin = %galaxy<origin> // </>.IO;
    $!bulge  = $!origin.add: '/etc/galaxy'.IO;
    $!halo   = $!origin.add: '/var/galaxy'.IO;
    $!disk   = $!halo.add:   '/galaxy.db'.IO;

    $!name   = %galaxy<name>   // chomp qx<hostname>;
    $!core   = %galaxy<core>   // chomp qx<uname -m>;
    $!yolo   = %galaxy<yolo>   // False;
    $!cool   = %galaxy<cool>   // False;
    $!pretty = %galaxy<pretty> // False;
  #  :$!gravity;
  #  #:$!blackhole;
  #  :$!nebula;

  #  $!db        = self!db;
	#	%!stars     = self!local-stars;   #Revist

  #
  say self;
	}
