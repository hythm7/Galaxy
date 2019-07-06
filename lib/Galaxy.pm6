use DDT;
use File::Temp;
use LibCurl::Easy;
use Archive::Libarchive;
use Archive::Libarchive::Constants;
use Galaxy::Physics;
use Galaxy::Gravity;
use Galaxy::Blackhole;
use Galaxy::Spacetime;
use Galaxy::Star;
use Galaxy::Planet;
use Galaxy::Nebula;

unit class Galaxy:ver<0.0.1>;
  also does Galaxy::Physics;

has Star   %!star;
has Nebula $!nebula;

submethod TWEAK ( ) {


  %!star = $!disk.all-stars.map({ .<name> => Star.new: |$_ });

  $!nebula = Nebula.new: source => %!law<nebula>;

  given %!law<cmd> {

    self.galaxy(    |%!law<galaxy>    ) when 'galaxy';
    self.star(      |%!law<star>      ) when 'star';
    self.planet(    |%!law<planet>    ) when 'planet';
    self.gravity(   |%!law<gravity>   ) when 'gravity';
    self.blackhole( |%!law<blackhole> ) when 'blackhole';
    self.spacetime( |%!law<spacetime> ) when 'spacetime';

  }

}

multi method galaxy ( ) {
  say '--- galaxy ---';
  say %!star;
  #self!stable;
}

multi method galaxy ( :@star! ) {
  say '--- galaxy star ---';

  say 'opppppensssssl';
  for @star -> %star {
    my $star =  %!star.values.first( * ≅ %star );


    .say for $star.planet.map( -> $planet { ~$star.origin.add: $planet.path } );
  }

}

method !stable ( ) {

  so all %!star.values.hyper.map( -> $star {
    so all $star.cluster.map( -> %cluster { %!star{%cluster<name>} ≅ %cluster });
  });

}

multi method galaxy ( :$event! ) {
  say '--- galaxy event ---';
}

method gravity ( IO :$origin = '/'.IO, :$cluster = False, :@star!  ) {
  say '--- gravity ---';

  my @resolved = self.resolve: :@star, :$cluster;

  my $tmp = tempdir;

  for @resolved -> %star {

    my $stardir = $tmp.IO.add: %star<star>;
    $stardir.mkdir;

    my $xyz = $stardir ~ '.xyz';

    LibCurl::Easy.new( URL => %star<location>.Str,
      download => $xyz.Str,
      :followlocation ).perform;


    my $a = Archive::Libarchive.new: operation => LibarchiveExtract, file => $xyz.Str,
      flags => ARCHIVE_EXTRACT_TIME +| ARCHIVE_EXTRACT_PERM +| ARCHIVE_EXTRACT_ACL +| ARCHIVE_EXTRACT_FFLAGS;

    $a.extract: &extract, $!origin.add($origin).Str;
    $a.close;

    #$!disk.clean;
    %star<origin> = ~$origin;
    $!disk.add-star: |%star;

    sub extract ( Archive::Libarchive::Entry $e --> Bool ) {

      %star<planet>.push:
      %(
        path   => $e.pathname,
        type   => $e.filetype,
        mode   => $e.mode,
        perm   => $e.perm,
        size   => $e.size,
      );

      True;
    }

  }


}

method blackhole ( :$cluster = False, :@star!  ) {
  say '--- blackhole ---';

  for @star -> %star {

    my $star = %!star.values.first( * ≅ %star );

    for $star.planet -> $planet {

      my $file = $!origin.add( $star.origin ).add( $planet.path );
      my $dir  = $file.dirname;

      #$file.unlink;
      #$dir.IO.rmdir unless dir $dir;

    }

    $!disk.remove-star: star => $star.star;

  }
}



method resolve ( :@star, Bool :$cluster ) {
  my ( @*winner, @*upgraded, @*downgraded );

  for @star -> %star {
    self!candi: :%star, :$cluster;
  }

  @*winner;

}

method !candi ( :%star, :$cluster = False ) {

  # Warning: Spaghetti incoming!

  for $!nebula.locate( |%star ) -> %candi {

    next unless %candi ~~ self;

    for %candi<cluster>.flat -> %star {

      last unless $cluster;
      last unless %star;

      self!candi: :%star, :$cluster;
    }

    my %won = @*winner.first({ .<name> ~~ %candi<name> }).hash;

    if %won {

      last if Version.new(%won<age>) ~~ Version.new(%star<age> // '');

      my @cluster = @*winner.grep({ any .<cluster>>><name> ~~ %won<name> }).map({ .<cluster>.first({ .<name> ~~ %won<name> }) });

      fail "{%star<name>} {%star<age>} conflicts with {%won<age>}"
        unless Version.new(%candi<age>) ~~ all @cluster.map({ Version.new($_<age> // '') });

      @*winner .= grep: not * eqv %won;

    }
      @*winner.push: %candi;
      last;
  }

  fail "Can not find candis for {%star<name>} {%star<age>}"
    unless @*winner.first({ .<name> ~~ %star<name> });

}

method planet ( :$planet!  ) {
  say '--- planet ---';
}

method star ( :@star!  ) {
  say '--- star ---';
}

method spacetime ( :$event!  ) {
  say '--- spacetime ---';
}

multi method ACCEPTS ( Galaxy:D: %candi --> Bool:D ) {

  return True unless %!star{%candi<name>};
  return True if %candi ~~ all %!star.values.grep({ any .cluster.map({ .<name> ~~ %candi<name> }) });
  return False;

}

multi infix:<≅> ( Star $star, %star --> Bool:D ) {

  return False unless $star;

  return False unless $star.name ~~ %star<name>;
  return False unless $star.age  ~~ Version.new: %star<age> // '';
  return False unless $star.core ~~ %star<core>;
  return False unless $star.form ~~ %star<form>;
  return False unless $star.tag  ~~ %star<tag>;

  True;
}


