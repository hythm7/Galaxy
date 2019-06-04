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
has           %!cluster;
has Nebula    $!nebula;

submethod TWEAK ( ) {


  $!db.query( 'select * from star' ).hashes.hyper.map( -> %star {

    my @planet = $!db.query( 'select * from planet where star = $star', star => %star<name> ).hashes;
    %star.push: ( :@planet );

    %!star.push: ( %star<name> => Star.new: |%star; );

  });

  $!db.query( 'select * from cluster' ).hashes.hyper.map( -> %cluster {

    %!cluster.push: ( %cluster<star> =>  %cluster );

    %!star{%cluster<star>}.cluster-add: star => %!star{%cluster<name>};

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
}

multi method galaxy ( :@star! ) {
  say '--- galaxy star ---';

  for @star -> %star {

    my $star =  %!star{%star<name>};

    self!cluster: :$star;
  }
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

method !cluster ( Star :$star! ) {
  .say for %!star{$star.name}.cluster;
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
