#!/usr/bin/env perl6

use lib <lib>;

use Galaxy::Grammar::Cmd;


my $cnf = 'g origin /tmp';

my $actions = Galaxy::Grammar::Cmd::Actions;

my $parser = Galaxy::Grammar::Cmd.new;

my $m = $parser.parse($cnf, :$actions).ast;

say $m;


