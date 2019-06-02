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
  say @star;
}

multi method galaxy ( :$event! ) {
  say '--- galaxy event ---';
}

method gravity ( :$origin = $!origin, :$cluster = False, :@star!  ) {
  say '--- gravity ---';
  #my @candis = @star.hyper.map( -> %star { $!nebula.locate: |%star });

  my %star = @star.head;

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

method !candi ( :$star, Int :$indent = 0 ) {

  for $!nebula.locate( |$star ) -> $candi {

    next unless self!accepts: :$candi;

    for $candi<cluster>.flat -> $star {

      next unless $star;
      self!candi: :$star, indent => $indent + 2;
    }

    my $won = @*winner.first({ .<name> ~~ $candi<name> });

    if $won {

      fail "{$star<name>} {$star<age>} conflicts with {$won<age>}"
        unless Version.new($won<age>) ~~ Version.new($star<age>);

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
