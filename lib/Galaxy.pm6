use Galaxy::Physics;
use Galaxy::Gravity;
use Galaxy::Blackhole;
use Galaxy::Spacetime;
use Galaxy::Star;
use Galaxy::Planet;
use Galaxy::Nebula;

unit class Galaxy:ver<0.0.1>;
  also does Galaxy::Physics;

has Gravity   $!gravity;
has Blackhole $!blackhole;
has Star      $!star;
has Planet    $!planet;
has Spacetime $!spacetime;
has Nebula    @!nebula;

submethod TWEAK ( ) {

  $!gravity   = Gravity.new;
  $!blackhole = Blackhole.new;
  $!spacetime = Spacetime.new;
  $!star      = Star.new;
  $!planet    = Planet.new;

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

method gravity ( :$origin = $!origin, :$core = $!core, :$cluster = False, :@stars!  ) {

  say '--- gravity ---';
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
