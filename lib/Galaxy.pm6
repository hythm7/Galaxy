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


  $!disk.all-stars.map({ %!star.push( .<star> => Star.new: |$_ ) });

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

  for @star -> %star {
    say %!star.values.first( * ≅ %star ).origin;
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

    #say $origin;
    %star.push: ( origin => ~$origin ) if $origin;
    #say %star;

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

    $!disk.clean;
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

multi infix:<≅> ( Star $star, %star --> Bool:D ) {

  return False unless $star;
  return True  if $star.star ~~ %star<star>;

  return False unless $star.name ~~ %star<name>;
  return False unless $star.age  ~~ Version.new: %star<age> // '';
  return False unless $star.core ~~ %star<core>;
  return False unless $star.form ~~ %star<form>;
  return False unless $star.tag  ~~ %star<tag>;

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
