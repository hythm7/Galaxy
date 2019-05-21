#!/usr/bin/env perl6

use lib <lib>;

use Galaxy::Grammar::Nebula;


my $nbl = 'cnf/nebula'.IO;

my $actions = Galaxy::Grammar::Nebula::Actions;

my $parser = Galaxy::Grammar::Nebula.new;

my $m = $parser.parsefile($nbl, :$actions);

say $m.ast;


