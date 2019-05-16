use Hash::Merge::Augment;
use Galaxy::Grammar::Cmd;
use Galaxy::Grammar::Cnf;

unti role Galaxy::Physics;
  has %.laws;

  submethod BUILD ( ) {

    my $cmd = Galaxy::Grammar::Cmd.new.parse(@*ARGS, actions => Galaxy::Grammar::Cmd::Actions).ast;
    my $origin   = $cmdi<galaxy><origin> // '/'.IO;

    #my $bulge    = $origin.add: 'etc/galaxy/';
    #my $halo     = $origin.add: 'var/galaxy/';

    #my $lawsfile = $bulge.add: 'laws';
    #my $disk     = $halo.add:  'galaxy.db';

    # now laws file? generate one!
    my $cnf = Galaxy::Grammar::Cnf.new.parsefile($lawsfile, actions => Galaxy::Grammar::Cnf::Actions).ast;

    my %laws = $cnf.merge: $cmd;

    my $name = %laws<galaxy><name> // chomp qx<hostname>;



  }
