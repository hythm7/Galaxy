#!/usr/bin/env perl6

use lib <lib>;

use Galaxy::Grammar::Star;


my $star = 'rakudo-star-0.0.7-x86_64-77-hhh.xyz';

my $actions = Galaxy::Grammar::Star::Actions;

my $parser = Galaxy::Grammar::Star.new;

my $m = $parser.parse( $star, :$actions );

say $m.ast;


