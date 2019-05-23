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

multi method galaxy ( :@stars! ) {
  say '--- galaxy star ---';
}

multi method galaxy ( :$event! ) {
  say '--- galaxy event ---';
}

method gravity ( :$origin = $!origin, :$cluster = False, :@stars!  ) {
  say '--- gravity ---';

  my @candi = @stars.hyper.map({ $!nebula.locate: |%^star });
  say @candi;
}

method blackhole ( :$cluster = False, :@stars!  ) {
  say '--- blackhole ---';
}

method planet ( :$planet!  ) {
  say '--- planet ---';
}

method star ( :@stars!  ) {
  say '--- star ---';
}

method spacetime ( :$event!  ) {
  say '--- spacetime ---';
}
