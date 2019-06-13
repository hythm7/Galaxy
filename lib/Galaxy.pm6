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

has Star      %!star;
has Nebula    $!nebula;

submethod TWEAK ( ) {

  $!db.query( 'select * from star' ).hashes.hyper.map( -> %star {

    my @planet  = $!db.query( 'select * from planet  where star = $star', star => %star<name> ).hashes;
    my @cluster = $!db.query( 'select * from cluster where star = $star', star => %star<name> ).hashes;

    %star.push: ( :@planet );
    %star.push: ( :@cluster );


    %!star.push: ( %star<name> => Star.new: |%star; );

  });


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
    self!stable;
}

multi method galaxy ( :@star! ) {
  say '--- galaxy star ---';

  .say for @star;

}

method !stable ( ) {

  so all %!star.values.hyper.map( -> $star {
    so all $star.cluster.map( -> %cluster { %!star{%cluster<name>} ≅ %cluster });
  });

}

multi method galaxy ( :$event! ) {
  say '--- galaxy event ---';
}

method gravity ( :$origin = $!origin, :$cluster = False, :@star!  ) {
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

    my $buffer = slurp $xyz, :bin;
    my $a = Archive::Libarchive.new: operation => LibarchiveRead, file => $buffer;
    my Archive::Libarchive::Entry $entry .= new;
    while $a.next-header($entry) {
      %star<planet>.push:
      {
        name  => $entry.pathname,
        owner => $entry.uid,
        gid   => $entry.gid,
        type  => $entry.filetype,
        mode  => $entry.mode,
      }

      $a.data-skip;
    }


    #my $e = Archive::Libarchive.new: operation => LibarchiveExtract, file => $xyz.Str,
    #  flags => ARCHIVE_EXTRACT_TIME +| ARCHIVE_EXTRACT_PERM +| ARCHIVE_EXTRACT_ACL +| ARCHIVE_EXTRACT_FFLAGS;

    #$e.extract: ~$stardir;
    #$e.close;


  }


}

method resolve ( :@star, Bool :$cluster ) {
  my @*winner;

  for @star -> $star {
    self!candi: :$star, :$cluster;
  }

  @*winner;

}

method !candi ( :$star, :$cluster = False ) {

  for $!nebula.locate( |$star ) -> $candi {

    next unless self!accepts: :$candi;

    for $candi<cluster>.flat -> $star {

      last unless $cluster;
      last unless $star;
      self!candi: :$star;
    }

    my $won = @*winner.first({ .<name> ~~ $candi<name> });

    if $won {

      fail "{$star<name>} {$star<age>} conflicts with {$won<age>}"
        unless Version.new($won<age>) ~~ Version.new($star<age> // '');

      next;
    }
    else {

      @*winner.push: $candi;
      last;
    }
  }

  my $winner = @*winner.first({ .<name> ~~ $star<name> });

  fail "Can not find candis for $star<name>" unless $winner;

  return @*winner;



}

method blackhole ( :$cluster = False, :@star!  ) {
  say '--- blackhole ---';
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

multi infix:<≅> ( Galaxy::Star $star, %cluster --> Bool:D ) {

  return False unless $star;
  return False unless $star.name ~~ %cluster<name>;
  return False unless $star.age  ~~ Version.new: %cluster<age> // '';
  return False unless $star.core ~~ %cluster<core>;
  return False unless $star.form ~~ %cluster<form>;
  return False unless $star.tag  ~~ %cluster<tag>;

  True;
}

method !accepts ( :$candi ) {
  given $candi {
    when .<name> ~~ 'gzip' {
      return True;
    }
    when .<name> ~~ 'bash' {
      return True;
    }
    when .<name> ~~ 'acl' {
      return True;
    }
    when .<name> ~~ 'coreutils' {
      return True;
    }
    when .<name> ~~ 'perl6' {
      return True;
    }
    when .<name> ~~ 'rakudo' {
      return True;
    }
    when .<name> ~~ 'galaxy' {
      return True;
    }

    default { return False }
  }
}
