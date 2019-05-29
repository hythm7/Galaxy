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

  my @resolved = self.resolve: :%star;

  say @resolved;


}


method resolve ( :$star ) {

  flat gather for $!nebula.locate(|$star) -> $star {

    next unless self.accepts: :$star;

    for flat $star<cluster> -> $star {;
      take self.resolve: :$star if $star;
    }

    take $star;

  }

}

method accepts ( :$star ) {
  return True;
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
