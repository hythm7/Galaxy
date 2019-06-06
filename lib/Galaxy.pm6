use DDT;
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
    say self!stable;
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


  my @resolved = self.resolve: :@star;

  ddt @resolved.map({ .<name>, .<age> });


}

method resolve ( :@star ) {
  my @*winner;

  for @star -> $star {
    self!candi: :$star;
  }

  @*winner;

}

method !candi ( :$star ) {

  for $!nebula.locate( |$star ) -> $candi {

    next unless self!accepts: :$candi;

    for $candi<cluster>.flat -> $star {

      next unless $star;
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
    when .<name> ~~ 'hythm' {
      return True;
    }
    when .<name> ~~ 'andromeda' {
      return True;
    }
    when .<name> ~~ 'timo' {
      return True;
    }
    when .<name> ~~ 'nimo' {
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
