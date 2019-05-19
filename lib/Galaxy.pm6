use Galaxy::Physics;

unit class Galaxy:ver<0.0.1>;
  also does Galaxy::Physics;

  multi method galaxy ( :@stars ) {
    say '--- galaxy star ---';
  }

  multi method galaxy ( :$event ) {
    say '--- galaxy event ---';
  }

  method gravity ( :$origin = $!origin, :$core = $!core, :$cluster = False, :@stars!  ) {

    say '--- gravity ---';
  }

  method blackhole ( :@stars!  ) {

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
