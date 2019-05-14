#!/usr/bin/env perl6

use lib <lib>;

use Galaxy::Grammar::Cnf;


my $cnf = 'cnf/laws'.IO;

my $actions = Galaxy::Grammar::Cnf::Actions;

my $parser = Galaxy::Grammar::Cnf.new;

my $m = $parser.parsefile($cnf, :$actions).ast;

say $m;


