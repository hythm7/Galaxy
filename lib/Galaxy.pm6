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
has Nebula    @!nebula;

submethod TWEAK ( ) {
  @!nebula = do for |%!law<nebula> { Nebula.new: |$^nebula }

  say @!nebula;

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

  #say @stars;
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
