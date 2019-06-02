use Cro::Uri;
use Galaxy::Planet;

unit class Galaxy::Star;

has Str     $.name;
has Version $.age;
has Str     $.core;
has Int     $.form;
has Str     $.tag;
has Str     $.tail;
has Str     $.chksum;

has Galaxy::Planet @.planet;
has Galaxy::Star   @.cluster;

has Cro::Uri $.location;
