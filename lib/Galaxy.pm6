use Galaxy::Physics;

unit class Galaxy:ver<0.0.1>;
  also does Galaxy::Physics;

  multi method galaxy ( :@stars ) {
    say $!yolo;
    say @stars;
  }

  multi method galaxy ( :$event ) {
    say $event;
  }

  method gravity ( :$origin = $!origin, :$core = $!core, :$cluster = False, :@stars!  ) {

    say $origin;
    say $core;
    say $cluster;
    say @stars;
  }

  method star ( :@stars!  ) {

  }
